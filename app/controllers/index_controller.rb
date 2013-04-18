include ActionView::Helpers::NumberHelper
class IndexController < ApplicationController
  before_filter :signed_in, :get_companies

  def index
    if @connection.access != 2
      sql = "SELECT feeds.*
          FROM feeds, feeds_users, users
          WHERE feeds.company_id = #{@company.id}
          AND (feeds.user_id = #{current_user.id}
          OR feeds.user_to = #{current_user.id}
          OR (feeds.id = feeds_users.feed_id AND feeds_users.user_id = #{current_user.id}))
          GROUP BY feeds.id ORDER BY feeds.created_at ASC"
      @feeds = Feed.includes(:users, :upload_files, :contacts).find_by_sql(sql)
    else
      @feeds = Feed.includes(:users, :upload_files, :contacts).where(:company_id => @company.id).order("created_at asc")
    end
    @feeds.each do |f|
      f[:files] = {}
      f.upload_files.each do |u|
        f[:files][u.id] = u
        f[:files][u.id][:path] = u.file
      end
      #f[:refers] = f.users
      f[:refers] = f.users.pluck(:id)
      f[:conts] = f.contacts.pluck(:id)
      #f[:status] = t("status_#{f.status_id}")
      f[:can_edit] = (@connection.access.to_i >= 2 || f.user_id == current_user.id || f.user_to == current_user.id) ? 1 : 0
    end
    @users = @company.users.includes(:user_companies)
    @users.each do |u|
      conn = u.user_companies.where({:company_id => @company.id}).first
      if conn.appointment.blank?
        u[:appointment] = ""
      else
        u[:appointment] = conn.appointment
      end
      if conn.head_id.to_i > 0
        u[:user_id] = conn.head_id.to_i
      else
        u[:user_id] = 0
      end
      u[:access] = conn.access.to_i
      u[:photo_path_thumb] = u.photo(:thumb)
      u[:photo_path_medium] = u.photo(:medium)
      u[:can_edit] = @connection.access.to_i >= 2 ? 1 : 0
      u[:can_edit_self] = current_user.id.to_i == u.id.to_i ? 1 : 0
      u[:owner] = u.id == @company.user_id ? 1 : 0
    end
    @companies.each do |comp|
      comp[:photo_path_thumb] = comp.photo(:thumb)
      comp[:photo_path_medium] = comp.photo(:medium)
      comp[:store_count_mb] = number_to_human_size(comp.store_count, {:locale => :en})
      comp[:store_limit_mb] = number_to_human_size(comp.store_limit, {:locale => :en})
    end
    @contacts = @company.contacts
    @contacts.each do |c|
      c[:can_edit] = @connection.access.to_i == 2 ? 1 : 0
    end
    @histories = @company.histories.order("id desc")
    @bills = Bill.where(feed_id: @feeds).all
    @positions = BillPosition.where(bill_id: @bills).all

    @chats = current_user.chats.order('chats.updated_at asc').includes(:users).includes(:chat_users).select("chats.id, chats.name, chats.created_at, chats.user_id, chat_users.unread, chat_users.is_hidden")
    @chats.each do |ch|
      ch['users'] = ch.users.map do |u|
        u[:photo_path_thumb] = u.photo(:thumb)
        u[:photo_path_medium] = u.photo(:medium)
      end
    end
    @messages = ChatMessage.where(chat_id: @chats.pluck("chats.id")).order('chat_messages.created_at asc')

    # выборка непрочитанных уведомлений
    @events = current_user.events.where( "status <= 19" ).where( :company_id => current_user.last_company)
  end

end

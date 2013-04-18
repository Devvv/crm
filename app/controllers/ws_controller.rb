class WsController < WebsocketRails::BaseController

  def connected
=begin
    @@user[current_user.id] ||= {}
    @@user[current_user.id][:companies] = current_user.companies
    if @@user[current_user.id][:companies]
      cids = @@user[current_user.id][:companies].pluck("companies.id")
      if current_user.last_company.to_i > 0
        c_id = current_user.last_company.to_i
      else
        c_id = @@user[current_user.id][:companies].first.id
        current_user.update_attribute :last_company, c_id
      end
      if c_id.in? cids
        @@user[current_user.id][:company] = @@user[current_user.id][:companies].where(:id => c_id).first
      else
        @@user[current_user.id][:company] = @@user[current_user.id][:companies].first
        current_user.update_attribute :last_company, c_id
      end
      @@user[current_user.id][:connection] = current_user.user_companies.where("user_companies.company_id = ?", @@user[current_user.id][:company].id).first
    end
=end
  end

end
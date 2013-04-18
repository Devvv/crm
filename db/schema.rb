# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130414220316) do

  create_table "authentications", :force => true do |t|
    t.string   "provider"
    t.string   "uuid"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "bill_positions", :force => true do |t|
    t.integer  "bill_id"
    t.decimal  "count",      :precision => 12, :scale => 2
    t.string   "units"
    t.decimal  "price",      :precision => 12, :scale => 2
    t.decimal  "sum",        :precision => 12, :scale => 2
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "name"
  end

  create_table "bills", :force => true do |t|
    t.integer  "feed_id"
    t.decimal  "sum",        :precision => 12, :scale => 2
    t.integer  "discount",                                  :default => 0
    t.string   "num"
    t.datetime "bill_date"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.string   "name"
    t.integer  "user_id"
    t.integer  "status_id"
  end

  create_table "chat_messages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "chat_id"
    t.text     "text"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "status",     :default => 0
  end

  create_table "chat_users", :force => true do |t|
    t.integer  "chat_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "unread"
    t.integer  "is_hidden"
  end

  create_table "chats", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.text     "text"
    t.integer  "user_id"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "rating"
    t.integer  "type_id",            :default => 0,           :null => false
    t.string   "code"
    t.integer  "public",             :default => 1,           :null => false
    t.float    "store_count",        :default => 0.0,         :null => false
    t.float    "store_limit",        :default => 104858000.0, :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "phone"
    t.string   "address"
    t.string   "inn"
    t.string   "kpp"
    t.string   "ogrn"
    t.date     "reg_date"
    t.datetime "type_to"
  end

  create_table "contacts", :force => true do |t|
    t.integer  "company_id"
    t.string   "name",       :default => ""
    t.string   "surname",    :default => ""
    t.string   "subname",    :default => ""
    t.text     "text"
    t.string   "email",      :default => ""
    t.string   "phone",      :default => ""
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "user_id"
  end

  create_table "contacts_feeds", :id => false, :force => true do |t|
    t.integer "feed_id"
    t.integer "contact_id"
  end

  create_table "emails", :force => true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.string   "password"
    t.string   "server"
    t.integer  "port"
    t.string   "smtp_address"
    t.integer  "smtp_port"
    t.string   "smtp_domain"
    t.string   "smtp_user_name"
    t.string   "smtp_password"
    t.string   "smtp_authentication"
    t.boolean  "smtp_enable_starttls_auto"
    t.boolean  "active"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "emails_archives", :force => true do |t|
    t.integer  "user_id"
    t.string   "message_id"
    t.datetime "date"
    t.string   "subject"
    t.text     "text"
    t.string   "mailbox"
    t.boolean  "deleted"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "events", :force => true do |t|
    t.integer  "user_id"
    t.integer  "history_id"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "company_id"
    t.integer  "event_type"
    t.integer  "feed_id"
  end

  create_table "feeds", :force => true do |t|
    t.string   "name"
    t.text     "text"
    t.integer  "user_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "type_id",    :default => 0
    t.integer  "status_id",  :default => 0, :null => false
    t.datetime "start"
    t.datetime "end"
    t.float    "total"
    t.integer  "importance"
    t.integer  "company_id"
    t.integer  "comments",   :default => 0, :null => false
    t.integer  "user_to",    :default => 0, :null => false
    t.integer  "feed_id",    :default => 0, :null => false
    t.integer  "public",     :default => 0, :null => false
  end

  create_table "feeds_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "feed_id"
  end

  create_table "histories", :force => true do |t|
    t.integer  "user_id"
    t.integer  "type_id"
    t.integer  "feed_id"
    t.text     "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "company_id"
  end

  create_table "invites", :force => true do |t|
    t.integer  "user_from"
    t.integer  "user_to"
    t.integer  "company_id"
    t.string   "to"
    t.string   "code"
    t.datetime "expire"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "activated",  :default => 0, :null => false
    t.integer  "cr",         :default => 0, :null => false
  end

  create_table "payments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.float    "amount"
    t.integer  "plan"
    t.integer  "paid",       :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "upload_files", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "company_id"
    t.integer  "feed_id",           :default => 0, :null => false
    t.integer  "history_id",        :default => 0, :null => false
    t.integer  "user_id"
  end

  create_table "user_companies", :force => true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.integer  "access"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "appointment"
    t.integer  "head_id"
    t.integer  "public",      :default => 0, :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name",                   :default => ""
    t.string   "phone",                  :default => ""
    t.string   "surname",                :default => ""
    t.string   "subname",                :default => ""
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "rating"
    t.string   "vacancy"
    t.integer  "public",                 :default => 1,  :null => false
    t.text     "resume"
    t.integer  "active",                 :default => 1,  :null => false
    t.integer  "last_company"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end

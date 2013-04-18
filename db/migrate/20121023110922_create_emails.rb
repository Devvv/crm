class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.integer :user_id
      t.string :email
      t.string :password
      t.string :server
      t.integer :port
      t.string :smtp_address
      t.integer :smtp_port
      t.string :smtp_domain
      t.string :smtp_user_name
      t.string :smtp_password
      t.string :smtp_authentication
      t.boolean :smtp_enable_starttls_auto
      t.boolean :active

      t.timestamps
    end
  end
end

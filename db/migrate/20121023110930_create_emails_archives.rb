class CreateEmailsArchives < ActiveRecord::Migration
  def change
    create_table :emails_archives do |t|
      t.integer :user_id
      t.string :message_id
      t.datetime :date
      t.string :subject
      t.text :text
      t.string :mailbox
      t.boolean :deleted

      t.timestamps
    end
  end
end

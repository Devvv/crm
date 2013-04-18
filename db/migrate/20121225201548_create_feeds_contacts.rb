class CreateFeedsContacts < ActiveRecord::Migration
  def change
    create_table :contacts_feeds, :id => false do |t|
      t.integer :feed_id
      t.integer :contact_id
    end
  end
end

class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :name
      t.text :text
      t.references :user

      t.timestamps
    end
  end
end

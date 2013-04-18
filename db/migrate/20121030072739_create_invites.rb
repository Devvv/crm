class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :user_from
      t.integer :user_to
      t.integer :company_id
      t.string :to
      t.string :code
      t.datetime :expire

      t.timestamps
    end
  end
end

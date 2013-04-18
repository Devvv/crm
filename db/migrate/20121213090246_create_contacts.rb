class CreateContacts < ActiveRecord::Migration
  def change

    create_table :contacts do |t|
      t.integer :company_id
      t.string :name
      t.string :surname
      t.string :submane
      t.text :text
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end

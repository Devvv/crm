class CreateUserCompanies < ActiveRecord::Migration
  def change
    create_table :user_companies do |t|
      t.integer :user_id
      t.integer :company_id
      t.integer :access

      t.timestamps
    end
  end
end

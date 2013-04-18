class AddLastCompanyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_company, :integer
  end
end

class AddNamesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :surname, :string
    add_column :users, :subname, :string
  end
end

class AddFieldsToBills < ActiveRecord::Migration
  def change
    add_column :bills, :name, :string
    add_column :bills, :user_id, :integer
    add_column :bills, :status_id, :integer
  end
end

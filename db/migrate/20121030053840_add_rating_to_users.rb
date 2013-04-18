class AddRatingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rating, :integer
    add_column :companies, :rating, :integer
  end
end

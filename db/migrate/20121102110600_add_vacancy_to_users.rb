class AddVacancyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :vacancy, :string
  end
end

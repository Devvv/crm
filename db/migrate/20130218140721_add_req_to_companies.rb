class AddReqToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :phone, :string
    add_column :companies, :address, :string
    add_column :companies, :inn, :string
    add_column :companies, :kpp, :string
    add_column :companies, :ogrn, :string
    add_column :companies, :reg_date, :date
  end
end

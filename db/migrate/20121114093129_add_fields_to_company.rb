class AddFieldsToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :type_id, :integer
    add_column :companies, :code, :string
  end
end

class AddPlanToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :type_to, :datetime
  end
end

class AddAppointmentToUserCompanies < ActiveRecord::Migration
  def change
    add_column :user_companies, :appointment, :string
  end
end

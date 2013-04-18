class RemoveAppointmentFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :appointment
  end
end

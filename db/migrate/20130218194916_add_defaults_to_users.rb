class AddDefaultsToUsers < ActiveRecord::Migration
  def change
    change_column_default :contacts, :name, ""
    change_column_default :contacts, :surname, ""
    change_column_default :contacts, :subname, ""
    change_column_default :contacts, :phone, ""
    #change_column_default :contacts, :text, ""
    change_column_default :contacts, :email, ""
    change_column_default :users, :name, ""
    change_column_default :users, :subname, ""
    change_column_default :users, :surname, ""
    change_column_default :users, :phone, ""
  end
end

class ChandeSubmane < ActiveRecord::Migration
  def change
    rename_column :contacts, :submane, :subname
  end
end

class EventsAddCompanyAndType < ActiveRecord::Migration
  def up
    add_column :events, :company_id, :integer
    add_column :events, :event_type, :integer
  end

  def down
    remove_column :events, :company_id
    remove_column :events, :event_type
  end
end

class AddSmsAlertsToUser < ActiveRecord::Migration
  def up
    add_column :users, :sms_alerts, :boolean, default: true
  end

  def down
    remove_column :users, :sms_alerts
  end
end

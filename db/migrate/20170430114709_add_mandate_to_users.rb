class AddMandateToUsers < ActiveRecord::Migration
  def up
    add_column :users, :mandate, :string
    add_column :users, :gocardless_id, :string
    add_column :users, :last_payment_id, :string
    add_column :users, :subscription_id, :string
  end

  def down
    remove_column :users, :mandate
    remove_column :users, :gocardless_id
    remove_column :users, :last_payment_id
    remove_column :users, :subscription_id
  end
end

class AddPremiumToUser < ActiveRecord::Migration
  def change
    add_column :users, :premium, :boolean
    add_column :users, :valid_till, :date
  end
end

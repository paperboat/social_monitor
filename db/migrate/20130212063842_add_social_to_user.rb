class AddSocialToUser < ActiveRecord::Migration
  def change
    add_column :users, :facebook, :integer
    add_column :users, :twitter, :integer
    add_column :users, :linkedin, :integer
    add_column :users, :gplus, :integer
  end
end

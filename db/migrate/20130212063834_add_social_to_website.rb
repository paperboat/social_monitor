class AddSocialToWebsite < ActiveRecord::Migration
  def change
    add_column :websites, :facebook, :integer
    add_column :websites, :twitter, :integer
    add_column :websites, :linkedin, :integer
    add_column :websites, :gplus, :integer
  end
end

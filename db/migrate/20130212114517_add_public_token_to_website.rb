class AddPublicTokenToWebsite < ActiveRecord::Migration
  def change
    add_column :websites, :public_token, :string
  end
end

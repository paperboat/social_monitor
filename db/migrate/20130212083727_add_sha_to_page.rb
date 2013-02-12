class AddShaToPage < ActiveRecord::Migration
  def change
    add_column :pages, :sha, :string
  end
end

class AddPagesToUser < ActiveRecord::Migration
  def change
    add_column :users, :page_cnt, :integer
  end
end

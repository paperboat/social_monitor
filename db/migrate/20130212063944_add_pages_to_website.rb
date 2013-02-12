class AddPagesToWebsite < ActiveRecord::Migration
  def change
    add_column :websites, :page_cnt, :integer
  end
end

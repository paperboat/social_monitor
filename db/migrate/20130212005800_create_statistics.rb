class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.integer :page_id
      t.date :fetch_date
      t.integer :facebook
      t.integer :twitter
      t.integer :linkedin
      t.integer :gplus

      t.timestamps
    end
  end
end

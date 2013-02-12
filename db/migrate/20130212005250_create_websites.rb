class CreateWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.integer :user_id
      t.string :root_url
      t.string :name
      t.datetime :last_crawl
      t.integer :frequency

      t.timestamps
    end
  end
end

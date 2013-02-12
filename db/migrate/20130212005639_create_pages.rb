class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer :website_id
      t.text :body
      t.integer :code
      t.integer :depth
      t.text :headers
      t.string :redirect_to
      t.string :referer
      t.integer :response_time
      t.string :url
      t.string :page_title

      t.timestamps
    end
  end
end

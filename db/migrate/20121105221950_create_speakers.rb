class CreateSpeakers < ActiveRecord::Migration
  def change
    create_table :speakers do |t|
      t.string :name, null: false
      t.text :bio, null: false
      t.string :website_url
      t.timestamps null: false
    end
  end
end

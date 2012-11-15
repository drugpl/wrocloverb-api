class CreateSlots < ActiveRecord::Migration
  def change
    create_table :slots do |t|
      t.references :venue, null: false
      t.string :name, null: false
      t.text :description
      t.datetime :starting_at, null: false
      t.datetime :ending_at, null: false
      t.timestamps null: false
    end
  end
end

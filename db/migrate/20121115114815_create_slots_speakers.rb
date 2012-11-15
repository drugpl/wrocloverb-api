class CreateSlotsSpeakers < ActiveRecord::Migration
  def change
    create_table :slots_speakers do |t|
      t.references :speaker, null: false
      t.references :slot, null: false
    end
  end
end

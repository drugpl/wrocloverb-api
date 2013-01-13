class AddPhotoUrlToSpeaker < ActiveRecord::Migration
  def change
    add_column :speakers, :photo_url, :string
  end
end

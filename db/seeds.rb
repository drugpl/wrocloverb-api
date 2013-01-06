# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

filename = File.expand_path("../seeds.yml", __FILE__)
venues   = YAML.load_file(filename)

venues.each do |v|
  venue    = Venue.find_or_create_by_name v.fetch(:name)
  location = Location.new v.fetch(:latitude), v.fetch(:longtitude)
  venue.update_attributes :address => v.fetch(:address), :location => location

  v.fetch(:slots).each do |s|
    slot = Slot.find_or_create_by_name s.fetch(:name)
    slot.update_attributes :starting_at => s.fetch(:starting_at), :ending_at => s.fetch(:ending_at),
                           :name => s.fetch(:name), :venue => venue
    venue.slots << slot

    speakers = s.fetch(:speakers) { Array.new }
    speakers.each do |sp|
      speaker = Speaker.find_or_create_by_name sp.fetch(:name)
      speaker.update_attributes :bio => sp.fetch(:bio)
      slot.speakers << speaker

      speaker.save!
    end

    slot.save!
  end
  venue.save!
end


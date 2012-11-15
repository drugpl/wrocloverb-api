# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121115114815) do

  create_table "api_tokens", :force => true do |t|
    t.string   "token",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "attendees", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "website_url"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "organizers", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "website_url"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "venues", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "address",    :null => false
    t.string   "location"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "slots", :force => true do |t|
    t.integer  "venue_id",    :null => false
    t.string   "name",        :null => false
    t.text     "description"
    t.datetime "starting_at", :null => false
    t.datetime "ending_at",   :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.index ["venue_id"], :name => "index_slots_on_venue_id"
    t.foreign_key ["venue_id"], "venues", ["id"], :on_update => :no_action, :on_delete => :no_action
  end

  create_table "speakers", :force => true do |t|
    t.string   "name",        :null => false
    t.text     "bio",         :null => false
    t.string   "website_url"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "slots_speakers", :force => true do |t|
    t.integer "speaker_id", :null => false
    t.integer "slot_id",    :null => false
    t.index ["slot_id"], :name => "index_slots_speakers_on_slot_id"
    t.index ["speaker_id"], :name => "index_slots_speakers_on_speaker_id"
    t.foreign_key ["speaker_id"], "speakers", ["id"], :on_update => :no_action, :on_delete => :no_action
    t.foreign_key ["slot_id"], "slots", ["id"], :on_update => :no_action, :on_delete => :no_action
  end

  create_table "supporters", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "logo_url"
    t.string   "website_url"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end

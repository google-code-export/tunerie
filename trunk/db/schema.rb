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

ActiveRecord::Schema.define(:version => 20101127181710) do

  create_table "channels", :force => true do |t|
    t.string   "name"
    t.string   "alias"
    t.string   "frequency"
    t.string   "program_id"
    t.text     "description"
    t.string   "website_url"
    t.string   "program_feed_url"
    t.integer  "tuner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "devices", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "ip_address"
    t.string   "model_number"
    t.text     "features"
    t.string   "firmware_version"
    t.string   "firmware_copyright"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", :force => true do |t|
    t.string   "name"
    t.string   "ip_address"
    t.string   "port"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tuners", :force => true do |t|
    t.string   "address"
    t.integer  "device_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

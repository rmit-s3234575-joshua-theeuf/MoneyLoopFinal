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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180918004853) do

  create_table "api_keys", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "token"
    t.string   "service_provider_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "claims", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "customer_id"
    t.string   "company_id"
    t.string   "exposure"
    t.string   "date_of_origination"
    t.string   "credit_score"
  end

  create_table "companies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "name"
    t.string   "abn"
    t.string   "tfn"
    t.string   "acn"
    t.string   "contact_number"
    t.string   "contact_email"
    t.string   "company_type"
  end

  create_table "customers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "given_names"
    t.string   "surname"
    t.string   "email"
    t.string   "phone_mobile"
    t.string   "phone_home"
    t.string   "dob"
    t.string   "address"
    t.string   "employer_name"
    t.string   "job_title"
    t.string   "device_type"
    t.string   "device_os"
    t.string   "device_model"
    t.string   "device_screen_resolution"
    t.string   "network_service_provider"
    t.string   "ip_location"
    t.string   "time_zone"
    t.string   "time_of_day"
  end

  create_table "indices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

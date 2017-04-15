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

ActiveRecord::Schema.define(version: 20170413182146) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "currencies", id: :integer, force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "forecasts", force: :cascade do |t|
    t.integer  "base_currency_id"
    t.integer  "target_currency_id"
    t.integer  "last_date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["base_currency_id"], name: "index_forecasts_on_base_currency_id", using: :btree
    t.index ["last_date"], name: "index_forecasts_on_last_date", using: :btree
    t.index ["target_currency_id"], name: "index_forecasts_on_target_currency_id", using: :btree
  end

  create_table "historical_currency_rates", force: :cascade do |t|
    t.integer "date"
    t.integer "currency_id"
    t.decimal "rate"
    t.index ["currency_id"], name: "index_historical_currency_rates_on_currency_id", using: :btree
    t.index ["date"], name: "index_historical_currency_rates_on_date", using: :btree
  end

  create_table "rate_forecasts", force: :cascade do |t|
    t.integer "forecast_id"
    t.integer "date"
    t.decimal "rate"
    t.index ["date"], name: "index_rate_forecasts_on_date", using: :btree
    t.index ["forecast_id"], name: "index_rate_forecasts_on_forecast_id", using: :btree
  end

end

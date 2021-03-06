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

ActiveRecord::Schema.define(version: 2019_05_21_161541) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "institutions", force: :cascade do |t|
    t.string "name"
    t.string "institution_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.string "api_key"
    t.string "shortcode", null: false
    t.string "url", null: false
    t.string "electronic_path"
    t.string "physical_path"
  end

  create_table "titles", force: :cascade do |t|
    t.bigint "institution_id"
    t.string "title"
    t.string "author"
    t.string "publisher"
    t.string "call_number"
    t.string "library"
    t.string "location"
    t.string "material_type"
    t.date "receiving_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mms_id"
    t.string "subjects"
    t.string "isbn"
    t.string "publication_date"
    t.string "portfolio_name"
    t.date "portfolio_activation_date"
    t.date "portfolio_creation_date"
    t.string "classification_code"
    t.string "availability"
    t.boolean "iz", default: false
    t.string "call_number_sort"
    t.index ["institution_id"], name: "index_titles_on_institution_id"
  end

end

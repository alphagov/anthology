# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_08_06_180637) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.string "isbn"
    t.string "author"
    t.string "google_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "created_by_id"
    t.string "openlibrary_id"
  end

  create_table "copies", force: :cascade do |t|
    t.integer "book_id"
    t.integer "book_reference", null: false
    t.boolean "on_loan", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "missing", default: false
    t.integer "shelf_id"
  end

  create_table "loans", force: :cascade do |t|
    t.integer "user_id"
    t.integer "copy_id"
    t.string "state", default: "on_loan"
    t.datetime "loan_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "return_date"
    t.integer "returned_by_id"
    t.integer "returned_to_shelf_id"
  end

  create_table "shelves", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "email"
    t.string "provider"
    t.string "provider_uid"
    t.text "image_url"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end

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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180410010306) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "benefits_check_leads", force: true do |t|
    t.boolean  "popup",            null: false
    t.string   "email",            null: false
    t.string   "name",             null: false
    t.string   "phone",            null: false
    t.string   "referer",          null: false
    t.integer  "seeking_help_for", null: false
    t.integer  "insurance_type",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "benefits_check_notifications", force: true do |t|
    t.string   "subject",                      null: false
    t.text     "content",                      null: false
    t.text     "insurance_types", default: [],              array: true
    t.string   "submitted_from"
    t.string   "submitted_to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blazer_audits", force: true do |t|
    t.integer  "user_id"
    t.integer  "query_id"
    t.text     "statement"
    t.string   "data_source"
    t.datetime "created_at"
  end

  create_table "blazer_checks", force: true do |t|
    t.integer  "query_id"
    t.string   "state"
    t.text     "emails"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blazer_dashboard_queries", force: true do |t|
    t.integer  "dashboard_id"
    t.integer  "query_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blazer_dashboards", force: true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blazer_queries", force: true do |t|
    t.integer  "creator_id"
    t.string   "name"
    t.text     "description"
    t.text     "statement"
    t.string   "data_source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bloggers", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "full_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bloggers", ["email"], name: "index_bloggers_on_email", unique: true, using: :btree
  add_index "bloggers", ["reset_password_token"], name: "index_bloggers_on_reset_password_token", unique: true, using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "meta_name"
    t.text     "meta_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "category_subhead"
    t.boolean  "boostable"
  end

  create_table "category_links", force: true do |t|
    t.integer  "category_id"
    t.integer  "listing_id"
    t.boolean  "boosted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "category_links", ["listing_id", "category_id"], name: "index_category_links_on_listing_id_and_category_id", unique: true, using: :btree

  create_table "cities", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "state_id"
  end

  add_index "cities", ["slug"], name: "index_cities_on_slug", using: :btree

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "claims", force: true do |t|
    t.integer  "member_id"
    t.string   "approved"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.integer  "listing_id"
    t.string   "name"
    t.string   "email"
    t.string   "phone"
  end

  add_index "claims", ["listing_id"], name: "index_claims_on_listing_id", using: :btree
  add_index "claims", ["member_id"], name: "index_claims_on_member_id", using: :btree

  create_table "comments", force: true do |t|
    t.string   "initial"
    t.text     "body"
    t.integer  "rating_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "directories", force: true do |t|
    t.string   "name"
    t.string   "directory_type"
    t.text     "description"
    t.string   "meta_name"
    t.text     "meta_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  create_table "duplicate_listings", force: true do |t|
    t.integer  "listing_id",            null: false
    t.integer  "listing_associated_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "duplicate_listings", ["listing_id"], name: "index_duplicate_listings_on_listing_id", using: :btree

  create_table "insurances", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "insurances_listings", id: false, force: true do |t|
    t.integer "insurance_id"
    t.integer "listing_id"
  end

  add_index "insurances_listings", ["listing_id", "insurance_id"], name: "index_insurances_listings_on_listing_id_and_insurance_id", unique: true, using: :btree

  create_table "languages", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages_listings", id: false, force: true do |t|
    t.integer "language_id"
    t.integer "listing_id"
  end

  add_index "languages_listings", ["listing_id", "language_id"], name: "index_languages_listings_on_listing_id_and_language_id", unique: true, using: :btree

  create_table "listings", force: true do |t|
    t.string   "name"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "suffix"
    t.string   "title"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "old_city"
    t.string   "old_state"
    t.string   "zipcode"
    t.string   "phone"
    t.string   "website"
    t.text     "description"
    t.string   "meta_title"
    t.text     "meta_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "directory_id"
    t.string   "listing_type"
    t.string   "slug"
    t.decimal  "latitude",                      precision: 6, scale: 4
    t.decimal  "longitude",                     precision: 7, scale: 4
    t.string   "sort_name"
    t.boolean  "published"
    t.boolean  "featured"
    t.boolean  "custom"
    t.boolean  "state_boost"
    t.string   "added_by"
    t.string   "review_url"
    t.string   "fax"
    t.string   "facility_name"
    t.text     "additional_data"
    t.string   "map_image_file_name"
    t.string   "map_image_content_type"
    t.integer  "map_image_file_size"
    t.datetime "map_image_updated_at"
    t.string   "medium_map_image_file_name"
    t.string   "medium_map_image_content_type"
    t.integer  "medium_map_image_file_size"
    t.datetime "medium_map_image_updated_at"
    t.string   "small_map_image_file_name"
    t.string   "small_map_image_content_type"
    t.integer  "small_map_image_file_size"
    t.datetime "small_map_image_updated_at"
    t.integer  "city_id"
    t.boolean  "needs_reviewed"
    t.string   "full_name_field"
    t.boolean  "duplicate",                                             default: false
    t.integer  "number_of_duplicates"
    t.string   "old_slug"
    t.boolean  "paid_advertiser",                                       default: false
    t.boolean  "mark_for_deletion",                                     default: false
    t.string   "new_city"
    t.string   "new_state_abbreviation"
    t.string   "country",                                               default: "US"
    t.text     "custom_description"
    t.text     "custom_service"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "instagram"
  end

  add_index "listings", ["directory_id"], name: "index_listings_on_directory_id", using: :btree
  add_index "listings", ["duplicate"], name: "index_listings_on_duplicate", using: :btree
  add_index "listings", ["published"], name: "index_listings_on_published", using: :btree
  add_index "listings", ["slug"], name: "index_listings_on_slug", using: :btree

  create_table "members", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "is_administrator"
  end

  add_index "members", ["email"], name: "index_members_on_email", unique: true, using: :btree
  add_index "members", ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true, using: :btree

  create_table "posts", force: true do |t|
    t.string   "author"
    t.string   "title",              null: false
    t.text     "description",        null: false
    t.text     "content",            null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id",         null: false
    t.string   "creator_type",       null: false
    t.string   "meta_description"
    t.boolean  "published"
  end

  add_index "posts", ["creator_id", "creator_type"], name: "index_posts_on_creator_id_and_creator_type", using: :btree

  create_table "ratings", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "score"
    t.string   "initials"
    t.boolean  "attended"
    t.string   "approval"
    t.integer  "listing_id"
  end

  add_index "ratings", ["listing_id"], name: "index_ratings_on_listing_id", using: :btree

  create_table "reviews", force: true do |t|
    t.string   "name"
    t.text     "body"
    t.string   "photo_url"
    t.string   "permalink_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", force: true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uploads", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "listing_id"
  end

  add_index "uploads", ["listing_id"], name: "index_uploads_on_listing_id", using: :btree

  create_table "zipcodes", force: true do |t|
    t.string   "postal"
    t.string   "city"
    t.string   "state"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

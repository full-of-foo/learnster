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

ActiveRecord::Schema.define(version: 20140212144433) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.integer  "user_id"
    t.string   "action"
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["trackable_id"], name: "index_activities_on_trackable_id", using: :btree
  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

  create_table "api_keys", force: true do |t|
    t.string   "access_token",                null: false
    t.boolean  "active",       default: true, null: false
    t.string   "expires_at"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "api_keys", ["user_id"], name: "index_api_keys_on_user_id", using: :btree

  create_table "course_sections", force: true do |t|
    t.string   "section"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id"
    t.integer  "provisioned_by"
  end

  add_index "course_sections", ["course_id"], name: "index_course_sections_on_course_id", using: :btree
  add_index "course_sections", ["provisioned_by"], name: "index_course_sections_on_provisioned_by", using: :btree

  create_table "courses", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organisation_id"
    t.integer  "managed_by"
    t.string   "description"
    t.string   "identifier"
  end

  add_index "courses", ["identifier"], name: "index_courses_on_identifier", using: :btree
  add_index "courses", ["managed_by"], name: "index_courses_on_managed_by", using: :btree
  add_index "courses", ["organisation_id"], name: "index_courses_on_organisation_id", using: :btree
  add_index "courses", ["title"], name: "index_courses_on_title", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "enrolled_course_sections", force: true do |t|
    t.integer  "student_id"
    t.integer  "course_section_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active"
  end

  add_index "enrolled_course_sections", ["course_section_id"], name: "index_enrolled_course_sections_on_course_section_id", using: :btree
  add_index "enrolled_course_sections", ["student_id"], name: "index_enrolled_course_sections_on_student_id", using: :btree

  create_table "learning_modules", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "educator_id"
    t.integer  "organisation_id"
  end

  add_index "learning_modules", ["educator_id"], name: "index_learning_modules_on_educator_id", using: :btree
  add_index "learning_modules", ["organisation_id"], name: "index_learning_modules_on_organisation_id", using: :btree

  create_table "module_supplements", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "learning_module_id"
  end

  add_index "module_supplements", ["learning_module_id"], name: "index_module_supplements_on_learning_module_id", using: :btree

  create_table "organisations", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
  end

  create_table "section_modules", force: true do |t|
    t.integer  "learning_module_id"
    t.integer  "course_section_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "section_modules", ["course_section_id"], name: "index_section_modules_on_course_section_id", using: :btree
  add_index "section_modules", ["learning_module_id"], name: "index_section_modules_on_learning_module_id", using: :btree

  create_table "supplement_contents", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "module_supplement_id"
    t.string   "file_upload"
  end

  add_index "supplement_contents", ["module_supplement_id"], name: "index_supplement_contents_on_module_supplement_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "first_name"
    t.string   "surname"
    t.string   "type"
    t.datetime "last_login"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "admin_for"
    t.integer  "attending_org"
    t.string   "role"
    t.string   "confirmation_code"
    t.boolean  "confirmed",         default: false
  end

  add_index "users", ["role"], name: "index_users_on_role", using: :btree

end

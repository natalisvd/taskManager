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

ActiveRecord::Schema.define(version: 20160621074225) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "attach_files", force: :cascade do |t|
    t.text     "path"
    t.integer  "fileable_id"
    t.string   "fileable_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "attach_files", ["fileable_id"], name: "index_attach_files_on_fileable_id", using: :btree
  add_index "attach_files", ["fileable_type"], name: "index_attach_files_on_fileable_type", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "content"
    t.integer  "user_id"
    t.integer  "comment_id"
    t.integer  "task_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "commentable_id"
    t.string   "commentable_type"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["task_id"], name: "index_comments_on_task_id", using: :btree

  create_table "files_comments", force: :cascade do |t|
    t.integer  "comment_id"
    t.string   "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "files_ideas", force: :cascade do |t|
    t.string   "file_name"
    t.text     "file_path"
    t.integer  "idea_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "files_ideas", ["idea_id"], name: "index_files_ideas_on_idea_id", using: :btree

  create_table "folders", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "folders", ["user_id"], name: "index_folders_on_user_id", using: :btree

  create_table "ideas", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "ideas", ["user_id"], name: "index_ideas_on_user_id", using: :btree

  create_table "items", force: :cascade do |t|
    t.string   "item"
    t.boolean  "status"
    t.integer  "note_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "items", ["note_id"], name: "index_items_on_note_id", using: :btree

  create_table "news", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "description"
    t.datetime "news_date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "note_files", force: :cascade do |t|
    t.text     "file_path"
    t.integer  "note_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "note_files", ["note_id"], name: "index_note_files_on_note_id", using: :btree

  create_table "notes", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.text     "file_path"
    t.text     "color"
    t.integer  "user_id"
    t.integer  "notable_id"
    t.string   "notable_type"
    t.date     "date"
    t.text     "tags"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "notes", ["notable_id"], name: "index_notes_on_notable_id", using: :btree
  add_index "notes", ["notable_type"], name: "index_notes_on_notable_type", using: :btree
  add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "description", default: ""
    t.integer  "creator_id",               null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "projects", ["creator_id"], name: "index_projects_on_creator_id", using: :btree

  create_table "schedules", force: :cascade do |t|
    t.string   "description"
    t.integer  "start_hours"
    t.integer  "start_minutes"
    t.integer  "duration_hours"
    t.integer  "duration_minutes"
    t.integer  "week_id"
    t.integer  "day_number"
    t.string   "color"
    t.string   "comment"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "schedules", ["week_id"], name: "index_schedules_on_week_id", using: :btree

  create_table "task_stages", force: :cascade do |t|
    t.integer  "task_id"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "task_stages", ["task_id"], name: "index_task_stages_on_task_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "title"
    t.text     "description",   default: ""
    t.integer  "project_id"
    t.integer  "executor_id"
    t.integer  "parent_id"
    t.string   "status"
    t.integer  "time_estimate"
    t.integer  "elapsed_time"
    t.date     "release_date"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "tasks", ["executor_id"], name: "index_tasks_on_executor_id", using: :btree
  add_index "tasks", ["parent_id"], name: "index_tasks_on_parent_id", using: :btree
  add_index "tasks", ["project_id"], name: "index_tasks_on_project_id", using: :btree

  create_table "time_works", force: :cascade do |t|
    t.integer  "time"
    t.integer  "user_id"
    t.integer  "price"
    t.string   "status_project"
    t.datetime "day"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "time_works", ["user_id"], name: "index_time_works_on_user_id", using: :btree

  create_table "user_to_projects", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_to_projects", ["project_id"], name: "index_user_to_projects_on_project_id", using: :btree
  add_index "user_to_projects", ["user_id"], name: "index_user_to_projects_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.date     "birthday"
    t.text     "avatar"
    t.integer  "salary"
    t.date     "employment_date"
    t.string   "skype"
    t.string   "phone"
    t.string   "name"
    t.string   "patronymic"
    t.string   "surname"
    t.text     "detalies"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "weeks", force: :cascade do |t|
    t.integer  "week_num"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "weeks", ["user_id"], name: "index_weeks_on_user_id", using: :btree

  add_foreign_key "comments", "tasks"
end

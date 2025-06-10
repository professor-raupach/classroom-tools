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

ActiveRecord::Schema[8.0].define(version: 2025_06_10_013429) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "attendances", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_session_id", null: false
    t.datetime "timestamp", null: false
    t.string "ip_address"
    t.text "user_agent"
    t.string "cookie_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.index ["course_session_id"], name: "index_attendances_on_course_session_id"
    t.index ["user_id", "course_session_id"], name: "index_attendances_on_user_id_and_course_session_id", unique: true
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "course_sessions", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.datetime "attendance_checkin_ended_at"
    t.index ["course_id"], name: "index_course_sessions_on_course_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "course_number"
    t.string "title"
    t.bigint "instructor_id", null: false
    t.integer "year"
    t.string "semester"
    t.date "start_date"
    t.date "end_date"
    t.time "start_time"
    t.time "end_time"
    t.boolean "monday"
    t.boolean "tuesday"
    t.boolean "wednesday"
    t.boolean "thursday"
    t.boolean "friday"
    t.boolean "saturday"
    t.boolean "sunday"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tutor_id"
    t.index ["instructor_id"], name: "index_courses_on_instructor_id"
    t.index ["tutor_id"], name: "index_courses_on_tutor_id"
  end

  create_table "enrollments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_enrollments_on_course_id"
    t.index ["user_id"], name: "index_enrollments_on_user_id"
  end

  create_table "help_queues", force: :cascade do |t|
    t.bigint "course_session_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_session_id"], name: "index_help_queues_on_course_session_id"
  end

  create_table "help_requests", force: :cascade do |t|
    t.bigint "help_queue_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["help_queue_id"], name: "index_help_requests_on_help_queue_id"
    t.index ["user_id"], name: "index_help_requests_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "student_id"
    t.boolean "student", default: true
    t.boolean "instructor", default: false
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "attendances", "course_sessions"
  add_foreign_key "attendances", "users"
  add_foreign_key "course_sessions", "courses"
  add_foreign_key "courses", "users", column: "instructor_id"
  add_foreign_key "courses", "users", column: "tutor_id"
  add_foreign_key "enrollments", "courses"
  add_foreign_key "enrollments", "users"
  add_foreign_key "help_queues", "course_sessions"
  add_foreign_key "help_requests", "help_queues"
  add_foreign_key "help_requests", "users"
end

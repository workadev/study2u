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

ActiveRecord::Schema[7.0].define(version: 2023_09_28_023547) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "actions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "category_id"
    t.string "action_key"
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_staff", default: false
    t.index ["action_key"], name: "index_actions_on_action_key", unique: true
    t.index ["category_id"], name: "index_actions_on_category_id"
  end

  create_table "admins", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "contact_no"
    t.text "avatar_data"
    t.uuid "role_id"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_admins_on_role_id"
  end

  create_table "articles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.string "subtitle"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "institution_id"
    t.string "userable_type"
    t.uuid "userable_id"
    t.index ["institution_id"], name: "index_articles_on_institution_id"
    t.index ["userable_id", "userable_type"], name: "index_articles_on_userable_id_and_userable_type"
  end

  create_table "branches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "major_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["major_id"], name: "index_branches_on_major_id"
  end

  create_table "categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "conversation_members", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "conversation_id"
    t.string "last_read"
    t.string "status"
    t.boolean "online", default: false
    t.integer "unread"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "userable_type"
    t.uuid "userable_id"
    t.index ["conversation_id"], name: "index_conversation_members_on_conversation_id"
    t.index ["userable_type", "userable_id"], name: "index_conversation_members_on_userable_type_and_userable_id"
  end

  create_table "conversations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "last_message_id"
    t.datetime "last_message_updated_at"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["last_message_id"], name: "index_conversations_on_last_message_id"
  end

  create_table "devices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "login_activity_id"
    t.string "app_version"
    t.string "mac_address"
    t.string "platform"
    t.string "refresh_token"
    t.string "status"
    t.string "deviceable_type"
    t.uuid "deviceable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "reset_password", default: false
    t.boolean "online"
    t.index ["deviceable_id", "deviceable_type"], name: "index_devices_on_deviceable_id_and_deviceable_type"
    t.index ["login_activity_id"], name: "index_devices_on_login_activity_id"
  end

  create_table "images", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "image_data"
    t.string "imageable_type"
    t.uuid "imageable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id"
  end

  create_table "institution_interests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "interest_id"
    t.uuid "institution_id"
    t.index ["institution_id"], name: "index_institution_interests_on_institution_id"
    t.index ["interest_id"], name: "index_institution_interests_on_interest_id"
  end

  create_table "institution_majors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "major_id"
    t.uuid "institution_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "fee"
    t.string "duration_normal"
    t.string "duration_extra"
    t.string "intake", array: true
    t.index ["institution_id"], name: "index_institution_majors_on_institution_id"
    t.index ["major_id", "institution_id"], name: "index_institution_majors_on_major_id_and_institution_id", unique: true
    t.index ["major_id"], name: "index_institution_majors_on_major_id"
  end

  create_table "institution_study_levels", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "study_level_id"
    t.uuid "institution_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["institution_id"], name: "index_institution_study_levels_on_institution_id"
    t.index ["study_level_id", "institution_id"], name: "institution_study_level_institution", unique: true
    t.index ["study_level_id"], name: "index_institution_study_levels_on_study_level_id"
  end

  create_table "institutions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "institution_type"
    t.string "size"
    t.string "area"
    t.string "ownership"
    t.string "short_desc"
    t.string "description"
    t.string "post_code"
    t.string "address"
    t.string "reputation"
    t.string "city"
    t.string "country"
    t.string "status"
    t.string "latitude"
    t.string "longitude"
    t.text "logo_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "created_by_id"
    t.string "created_by_type"
    t.uuid "state_id"
    t.boolean "scholarship", default: false
    t.string "phone_number"
    t.string "url"
    t.index ["state_id"], name: "index_institutions_on_state_id"
  end

  create_table "interests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.text "icon_data"
    t.string "icon_color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "login_activities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "scope"
    t.string "strategy"
    t.string "identity"
    t.boolean "success"
    t.string "failure_reason"
    t.string "user_type"
    t.uuid "user_id"
    t.string "context"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "city"
    t.string "region"
    t.string "country"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at"
    t.index ["identity"], name: "index_login_activities_on_identity"
    t.index ["ip"], name: "index_login_activities_on_ip"
    t.index ["user_type", "user_id"], name: "index_login_activities_on_user"
  end

  create_table "major_interests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "major_id"
    t.uuid "interest_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["interest_id"], name: "index_major_interests_on_interest_id"
    t.index ["major_id", "interest_id"], name: "index_major_interests_on_major_id_and_interest_id", unique: true
    t.index ["major_id"], name: "index_major_interests_on_major_id"
  end

  create_table "majors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "conversation_id"
    t.uuid "parent_id"
    t.text "attachment_data"
    t.text "text"
    t.string "message_type"
    t.string "timetoken"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "userable_type"
    t.uuid "userable_id"
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["parent_id"], name: "index_messages_on_parent_id"
    t.index ["userable_type", "userable_id"], name: "index_messages_on_userable_type_and_userable_id"
  end

  create_table "role_actions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "role_id"
    t.uuid "action_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action_id"], name: "index_role_actions_on_action_id"
    t.index ["role_id"], name: "index_role_actions_on_role_id"
  end

  create_table "roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_staff", default: false
  end

  create_table "staff_institutions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "staff_id"
    t.uuid "institution_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["institution_id"], name: "index_staff_institutions_on_institution_id"
    t.index ["staff_id"], name: "index_staff_institutions_on_staff_id"
  end

  create_table "staffs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.text "avatar_data"
    t.string "title"
    t.string "description"
    t.uuid "role_id"
    t.uuid "current_qualification_id"
    t.string "nationality"
    t.date "birthday"
    t.boolean "online", default: false
    t.datetime "last_online_at"
    t.index ["confirmation_token"], name: "index_staffs_on_confirmation_token", unique: true
    t.index ["current_qualification_id"], name: "index_staffs_on_current_qualification_id"
    t.index ["email"], name: "index_staffs_on_email", unique: true
    t.index ["reset_password_token"], name: "index_staffs_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_staffs_on_role_id"
  end

  create_table "states", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "study_levels", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_institutions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "institution_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["institution_id"], name: "index_user_institutions_on_institution_id"
    t.index ["user_id", "institution_id"], name: "index_user_institutions_on_user_id_and_institution_id", unique: true
    t.index ["user_id"], name: "index_user_institutions_on_user_id"
  end

  create_table "user_interests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "interest_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["interest_id"], name: "index_user_interests_on_interest_id"
    t.index ["user_id", "interest_id"], name: "index_user_interests_on_user_id_and_interest_id", unique: true
    t.index ["user_id"], name: "index_user_interests_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "headline"
    t.text "about_me"
    t.string "phone_number"
    t.string "address"
    t.date "birthday"
    t.text "avatar_data"
    t.uuid "current_education_id"
    t.string "nationality"
    t.string "current_school"
    t.boolean "online"
    t.datetime "last_online_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["current_education_id"], name: "index_users_on_current_education_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "videos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "video_data"
    t.string "videoable_type"
    t.uuid "videoable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["videoable_type", "videoable_id"], name: "index_videos_on_videoable_type_and_videoable_id"
  end

end

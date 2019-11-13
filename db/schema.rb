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

ActiveRecord::Schema.define(version: 20191113040138) do

  create_table "admin_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "billings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "shop_id"
    t.bigint "user_id"
    t.integer "state", default: 1
    t.integer "payment_way"
    t.integer "price"
    t.integer "month"
    t.integer "year"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_billings_on_shop_id"
    t.index ["user_id"], name: "index_billings_on_user_id"
  end

  create_table "corporation_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "corporation_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["corporation_id"], name: "index_corporation_users_on_corporation_id"
    t.index ["user_id"], name: "index_corporation_users_on_user_id"
  end

  create_table "corporations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "kana", null: false
    t.string "tel", null: false
    t.string "postal_code"
    t.string "address"
    t.text "note"
    t.string "token"
    t.integer "ks_corporation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "ksc_token"
    t.string "jwt_token"
  end

  create_table "credit_cards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id", null: false
    t.string "card_no", null: false
    t.integer "sequence"
    t.integer "kind"
    t.string "holder_name", null: false
    t.string "stripe_card_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["user_id"], name: "index_credit_cards_on_user_id"
  end

  create_table "dropin_reservations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "facility_id", null: false
    t.bigint "facility_dropin_plan_id", null: false
    t.bigint "facility_dropin_sub_plan_id", null: false
    t.bigint "facility_key_id", null: false
    t.integer "user_id"
    t.integer "reservation_user_id"
    t.integer "payment_id"
    t.datetime "checkin"
    t.datetime "checkout"
    t.integer "state", default: 0
    t.integer "price", default: 0
    t.boolean "mail_send_flag", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "billing_id"
    t.index ["billing_id"], name: "index_dropin_reservations_on_billing_id"
    t.index ["facility_dropin_plan_id"], name: "index_dropin_reservations_on_facility_dropin_plan_id"
    t.index ["facility_dropin_sub_plan_id"], name: "index_dropin_reservations_on_facility_dropin_sub_plan_id"
    t.index ["facility_id"], name: "index_dropin_reservations_on_facility_id"
    t.index ["facility_key_id"], name: "index_dropin_reservations_on_facility_key_id"
  end

  create_table "facilities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "shop_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "image"
    t.text "description"
    t.integer "max_num", default: 0
    t.integer "facility_type", null: false
    t.string "address"
    t.float "lat", limit: 24
    t.float "lon", limit: 24
    t.string "detail_document"
    t.boolean "published", default: true
    t.integer "reservation_type", default: 1
    t.integer "ks_room_id"
    t.index ["shop_id"], name: "index_facilities_on_shop_id"
  end

  create_table "facility_dropin_plans", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "facility_id", null: false
    t.integer "plan_id"
    t.string "guide_mail_title"
    t.text "guide_mail_content"
    t.string "guide_file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["facility_id"], name: "index_facility_dropin_plans_on_facility_id"
  end

  create_table "facility_dropin_sub_plans", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "facility_dropin_plan_id", null: false
    t.string "name", null: false
    t.time "starting_time", null: false
    t.time "ending_time", null: false
    t.integer "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["facility_dropin_plan_id"], name: "index_facility_dropin_sub_plans_on_facility_dropin_plan_id"
  end

  create_table "facility_keys", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "facility_id", null: false
    t.integer "ks_room_key_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["facility_id"], name: "index_facility_keys_on_facility_id"
  end

  create_table "facility_plans", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "facility_id", null: false
    t.bigint "plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["facility_id"], name: "index_facility_plans_on_facility_id"
    t.index ["plan_id"], name: "index_facility_plans_on_plan_id"
  end

  create_table "facility_temporary_plan_prices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "facility_temporary_plan_id", null: false
    t.time "starting_time", null: false
    t.time "ending_time", null: false
    t.integer "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["facility_temporary_plan_id"], name: "index_prices_on_facility_temporary_plan_id"
  end

  create_table "facility_temporary_plans", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "facility_id", null: false
    t.bigint "plan_id"
    t.integer "ks_room_key_id", null: false
    t.string "guide_mail_title"
    t.text "guide_mail_content"
    t.string "guide_file"
    t.integer "standard_price_per_hour", null: false
    t.integer "standard_price_per_day", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["facility_id"], name: "index_facility_temporary_plans_on_facility_id"
    t.index ["plan_id"], name: "index_facility_temporary_plans_on_plan_id"
  end

  create_table "information", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "shop_id"
    t.string "title", null: false
    t.text "description", limit: 4294967295, null: false
    t.datetime "publish_time", default: "2018-01-01 00:00:00", null: false
    t.boolean "mail_send_flag", default: false
    t.integer "info_type", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "info_target_type", default: 2, null: false
    t.index ["shop_id"], name: "index_information_on_shop_id"
  end

  create_table "information_shops", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "information_id", null: false
    t.bigint "shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["information_id"], name: "index_information_shops_on_information_id"
    t.index ["shop_id"], name: "index_information_shops_on_shop_id"
  end

  create_table "payments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id", null: false
    t.bigint "corporation_id", null: false
    t.bigint "facility_id", null: false
    t.bigint "credit_card_id", null: false
    t.integer "price", null: false
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["corporation_id"], name: "index_payments_on_corporation_id"
    t.index ["credit_card_id"], name: "index_payments_on_credit_card_id"
    t.index ["facility_id"], name: "index_payments_on_facility_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "personal_identifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id", null: false
    t.string "front_img", null: false
    t.string "back_img"
    t.integer "card_type"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["user_id"], name: "index_personal_identifications_on_user_id"
  end

  create_table "plans", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "corporation_id", null: false
    t.string "name", null: false
    t.integer "price", null: false
    t.text "description"
    t.boolean "default_flag", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["corporation_id"], name: "index_plans_on_corporation_id"
  end

  create_table "reservations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "facility_id", null: false
    t.integer "user_id"
    t.integer "reservation_user_id"
    t.datetime "checkin"
    t.datetime "checkout"
    t.float "usage_period", limit: 24
    t.integer "state", default: 0, null: false
    t.integer "price", default: 0, null: false
    t.boolean "block_flag", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "num", default: 0
    t.integer "payment_id"
    t.boolean "mail_send_flag", default: false
    t.bigint "billing_id"
    t.string "ksc_reservation_no"
    t.index ["billing_id"], name: "index_reservations_on_billing_id"
    t.index ["facility_id"], name: "index_reservations_on_facility_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "shops", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "corporation_id", null: false
    t.string "name", null: false
    t.string "postal_code"
    t.string "address"
    t.decimal "lat", precision: 11, scale: 8
    t.decimal "lon", precision: 11, scale: 8
    t.string "tel"
    t.time "opening_time", null: false
    t.time "closing_time", null: false
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "calendar_url"
    t.integer "shop_type", default: 0
    t.index ["corporation_id"], name: "index_shops_on_corporation_id"
  end

  create_table "user_contracts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "corporation_id", null: false
    t.bigint "shop_id"
    t.bigint "user_id", null: false
    t.integer "plan_id"
    t.date "started_on", null: false
    t.date "finished_on"
    t.integer "state", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["corporation_id"], name: "index_user_contracts_on_corporation_id"
    t.index ["plan_id"], name: "index_user_contracts_on_plan_id"
    t.index ["shop_id"], name: "index_user_contracts_on_shop_id"
    t.index ["user_id"], name: "index_user_contracts_on_user_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "name", null: false
    t.string "tel"
    t.integer "state", default: 0, null: false
    t.integer "payway", default: 1, null: false
    t.string "stripe_customer_id"
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "user_type", default: 1
    t.integer "parent_id"
    t.string "parent_token"
    t.integer "max_user_num"
    t.boolean "advertise_notice_flag", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "campaign_id"
    t.integer "sms_verify_code"
    t.datetime "sms_sent_at"
    t.boolean "sms_verified", default: false
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

end

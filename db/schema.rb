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

ActiveRecord::Schema.define(version: 20180327060536) do

  create_table "admin_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "corporation_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "corporation_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "facilities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "shop_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "image"
    t.text "description"
    t.index ["shop_id"], name: "index_facilities_on_shop_id"
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

  create_table "information", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "shop_id", null: false
    t.string "title", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["shop_id"], name: "index_information_on_shop_id"
  end

  create_table "payments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id", null: false
    t.bigint "corporation_id", null: false
    t.bigint "facility_id", null: false
    t.bigint "credit_card_id", null: false
    t.string "price", null: false
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["corporation_id"], name: "index_payments_on_corporation_id"
    t.index ["credit_card_id"], name: "index_payments_on_credit_card_id"
    t.index ["facility_id"], name: "index_payments_on_facility_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
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
    t.bigint "user_id", null: false
    t.datetime "checkin", null: false
    t.datetime "checkout", null: false
    t.integer "state", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
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
    t.index ["corporation_id"], name: "index_shops_on_corporation_id"
  end

  create_table "user_contracts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "corporation_id", null: false
    t.bigint "shop_id"
    t.bigint "user_id", null: false
    t.bigint "plan_id", null: false
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
    t.boolean "advertise_notice_flag", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

end

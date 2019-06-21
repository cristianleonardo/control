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

ActiveRecord::Schema.define(version: 20190612072741) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contract_types", force: :cascade do |t|
    t.string   "abbreviation", default: "", null: false
    t.string   "name",         default: "", null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "contractor_types", force: :cascade do |t|
    t.string   "abbreviation", default: "", null: false
    t.string   "name",         default: "", null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "contractors", force: :cascade do |t|
    t.string   "name"
    t.string   "document_number"
    t.string   "document_type"
    t.string   "legal_representant_name"
    t.string   "legal_representant_document_number"
    t.string   "legal_representant_document_type"
    t.integer  "contractor_type_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "contracts", force: :cascade do |t|
    t.string   "contract_number",           null: false
    t.string   "process_number",            null: false
    t.string   "contractual_object"
    t.text     "description"
    t.datetime "start_date",                null: false
    t.datetime "end_date",                  null: false
    t.decimal  "value",                     null: false
    t.string   "state",                     null: false
    t.integer  "interventor_contractor_id"
    t.integer  "supervisor_contractor_id"
    t.integer  "contractor_id",             null: false
    t.integer  "contract_type_id",          null: false
    t.integer  "work_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["contract_type_id"], name: "index_contracts_on_contract_type_id", using: :btree
    t.index ["contractor_id"], name: "index_contracts_on_contractor_id", using: :btree
    t.index ["interventor_contractor_id"], name: "index_contracts_on_interventor_contractor_id", using: :btree
    t.index ["supervisor_contractor_id"], name: "index_contracts_on_supervisor_contractor_id", using: :btree
    t.index ["work_id"], name: "index_contracts_on_work_id", using: :btree
  end

  create_table "inputs", force: :cascade do |t|
    t.string   "name"
    t.string   "abbrevation"
    t.string   "input_type"
    t.string   "metrics"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "inventories", force: :cascade do |t|
    t.text     "code",                       null: false
    t.text     "state",         default: "", null: false
    t.date     "review_period"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "work_id"
    t.index ["work_id"], name: "index_inventories_on_work_id", using: :btree
  end

  create_table "inventory_inputs", force: :cascade do |t|
    t.decimal  "input_quantity"
    t.integer  "inventory_id"
    t.integer  "input_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["input_id"], name: "index_inventory_inputs_on_input_id", using: :btree
    t.index ["inventory_id"], name: "index_inventory_inputs_on_inventory_id", using: :btree
  end

  create_table "media", force: :cascade do |t|
    t.integer  "contract_id"
    t.string   "file"
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["contract_id"], name: "index_media_on_contract_id", using: :btree
  end

  create_table "payments", force: :cascade do |t|
    t.string   "code"
    t.text     "observations"
    t.string   "payment_type"
    t.boolean  "vat"
    t.boolean  "prepayment",     default: false
    t.float    "vat_percentage"
    t.datetime "date"
    t.decimal  "value"
    t.decimal  "base_value"
    t.decimal  "vat_value"
    t.integer  "contract_id"
    t.integer  "subcontract_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["contract_id"], name: "index_payments_on_contract_id", using: :btree
    t.index ["subcontract_id"], name: "index_payments_on_subcontract_id", using: :btree
  end

  create_table "provider_inputs", force: :cascade do |t|
    t.integer  "provider_id"
    t.integer  "input_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["input_id"], name: "index_provider_inputs_on_input_id", using: :btree
    t.index ["provider_id"], name: "index_provider_inputs_on_provider_id", using: :btree
  end

  create_table "providers", force: :cascade do |t|
    t.string   "name"
    t.string   "number"
    t.string   "indentifier"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "purchase_input_orders", force: :cascade do |t|
    t.decimal  "input_quantity"
    t.integer  "purchase_order_id"
    t.integer  "input_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["input_id"], name: "index_purchase_input_orders_on_input_id", using: :btree
    t.index ["purchase_order_id"], name: "index_purchase_input_orders_on_purchase_order_id", using: :btree
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.string   "order_number"
    t.string   "invoice_number"
    t.text     "detail"
    t.decimal  "base_value"
    t.decimal  "vat_value"
    t.decimal  "vat_percentage"
    t.integer  "inventory_id"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["inventory_id"], name: "index_purchase_orders_on_inventory_id", using: :btree
    t.index ["user_id"], name: "index_purchase_orders_on_user_id", using: :btree
  end

  create_table "subcontracts", force: :cascade do |t|
    t.string   "contract_number",           null: false
    t.string   "process_number",            null: false
    t.string   "contractual_object"
    t.text     "description"
    t.datetime "start_date",                null: false
    t.datetime "end_date",                  null: false
    t.decimal  "value",                     null: false
    t.integer  "contract_id",               null: false
    t.string   "state",                     null: false
    t.integer  "interventor_contractor_id"
    t.integer  "supervisor_contractor_id"
    t.integer  "contractor_id",             null: false
    t.integer  "contract_type_id",          null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["contract_id"], name: "index_subcontracts_on_contract_id", using: :btree
    t.index ["contract_type_id"], name: "index_subcontracts_on_contract_type_id", using: :btree
    t.index ["contractor_id"], name: "index_subcontracts_on_contractor_id", using: :btree
    t.index ["interventor_contractor_id"], name: "index_subcontracts_on_interventor_contractor_id", using: :btree
    t.index ["supervisor_contractor_id"], name: "index_subcontracts_on_supervisor_contractor_id", using: :btree
  end

  create_table "transactions", force: :cascade do |t|
    t.string   "transaction_type"
    t.text     "notes"
    t.datetime "transaction_date"
    t.integer  "purchase_order_id"
    t.integer  "inventory_id"
    t.integer  "user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["inventory_id"], name: "index_transactions_on_inventory_id", using: :btree
    t.index ["purchase_order_id"], name: "index_transactions_on_purchase_order_id", using: :btree
    t.index ["user_id"], name: "index_transactions_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "firstname",              default: "",    null: false
    t.string   "lastname",               default: "",    null: false
    t.boolean  "developer",              default: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "active",                 default: false
    t.boolean  "disabled",               default: false
    t.string   "contact_phone"
    t.string   "invitation_token"
    t.datetime "invitation_sent_at"
    t.string   "role_group"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "work_types", force: :cascade do |t|
    t.string   "name",        default: "", null: false
    t.string   "description", default: "", null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "works", force: :cascade do |t|
    t.string   "number",       default: "",    null: false
    t.text     "description",  default: "",    null: false
    t.decimal  "budget",       default: "0.0", null: false
    t.integer  "work_type_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["work_type_id"], name: "index_works_on_work_type_id", using: :btree
  end

  add_foreign_key "contracts", "works"
  add_foreign_key "inventory_inputs", "inputs"
  add_foreign_key "inventory_inputs", "inventories"
  add_foreign_key "media", "contracts"
  add_foreign_key "payments", "contracts"
  add_foreign_key "payments", "subcontracts"
  add_foreign_key "provider_inputs", "inputs"
  add_foreign_key "provider_inputs", "providers"
  add_foreign_key "purchase_input_orders", "inputs"
  add_foreign_key "purchase_input_orders", "purchase_orders"
  add_foreign_key "purchase_orders", "inventories"
  add_foreign_key "purchase_orders", "users"
  add_foreign_key "transactions", "inventories"
  add_foreign_key "transactions", "purchase_orders"
  add_foreign_key "transactions", "users"
  add_foreign_key "works", "work_types"
end

class AddNewTables < ActiveRecord::Migration[5.0]
  def change
    create_table :work_types do |t|
      t.string :name, null: false, default: ""
      t.string :description, null: false, default: ""

      t.timestamps
    end

    create_table :inventories do |t|
      t.text :code, null: false
      t.text :state, null: false, default: ""
      t.date :review_period

      t.timestamps
    end

    create_table :works do |t|
      t.string :number, null: false, default: ""
      t.text :description, null: false, default: ""
      t.decimal :budget, null: false, default: 0
      t.references :work_type, foreign_key: true

      t.timestamps
    end

    create_table :contract_types do |t|
      t.string :abbreviation, null: false, default: ""
      t.string :name, null: false, default: ""

      t.timestamps
    end

    create_table  :contracts do |t|
      t.string    :contract_number, null: false
      t.string    :process_number, null: false
      t.string    :contractual_object
      t.text      :description
      t.timestamp :start_date, null: false
      t.timestamp :end_date, null: false
      t.decimal   :value, null: false
      t.string    :state, null: false
      t.integer   :interventor_contractor_id
      t.integer   :supervisor_contractor_id
      t.integer   :contractor_id, null: false
      t.integer   :contract_type_id, null: false
      t.references :work, foreign_key: true

      t.timestamps

      t.timestamps
    end
    add_index :contracts, :interventor_contractor_id
    add_index :contracts, :supervisor_contractor_id
    add_index :contracts, :contractor_id
    add_index :contracts, :contract_type_id

    create_table  :subcontracts do |t|
      t.string    :contract_number, null: false
      t.string    :process_number, null: false
      t.string    :contractual_object
      t.text      :description
      t.timestamp :start_date, null: false
      t.timestamp :end_date, null: false
      t.decimal   :value, null: false
      t.integer   :contract_id, null: false
      t.string    :state, null: false
      t.integer   :interventor_contractor_id
      t.integer   :supervisor_contractor_id
      t.integer   :contractor_id, null: false
      t.integer   :contract_type_id, null: false

      t.timestamps
    end
    add_index :subcontracts, :interventor_contractor_id
    add_index :subcontracts, :supervisor_contractor_id
    add_index :subcontracts, :contractor_id
    add_index :subcontracts, :contract_type_id
    add_index :subcontracts, :contract_id

    create_table :contractor_types do |t|
      t.string :abbreviation, null: false, default: ""
      t.string :name, null: false, default: ""

      t.timestamps
    end

    create_table :contractors do |t|
      t.string :name
      t.string :document_number
      t.string :document_type
      t.string :legal_representant_name
      t.string :legal_representant_document_number
      t.string :legal_representant_document_type
      t.integer :contractor_type_id

      t.timestamps
    end

    create_table :payments do |t|
      t.string :code
      t.text :observations
      t.string :payment_type
      t.boolean :vat
      t.boolean :prepayment, default: false
      t.float :vat_percentage
      t.timestamp :date
      t.decimal :value
      t.decimal :base_value
      t.decimal :vat_value
      t.references :contract, foreign_key: true
      t.references :subcontract, foreign_key: true

      t.timestamps
    end

    create_table :media do |t|
      t.references :contract, foreign_key: true
      t.string :file
      t.string :name

      t.timestamps
    end

    create_table :providers do |t|
      t.string :name
      t.string :number
      t.string :indentifier

      t.timestamps
    end

    create_table :inputs do |t|
      t.string :name
      t.string :abbrevation
      t.string :input_type
      t.string :metrics
      t.text :description

      t.timestamps
    end

    create_table :provider_inputs do |t|
      t.references :provider, foreign_key: true
      t.references :input, foreign_key: true

      t.timestamps
    end

    create_table :inventory_inputs do |t|
      t.decimal :input_quantity
      t.references :inventory, foreign_key: true
      t.references :input, foreign_key: true

      t.timestamps
    end

    create_table :purchase_orders do |t|
      t.string :order_number
      t.string :invoice_number
      t.text :detail
      t.decimal :base_value
      t.decimal :vat_value
      t.decimal :vat_percentage
      t.references :inventory, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end

    create_table :purchase_input_orders do |t|
      t.decimal :input_quantity
      t.references :purchase_order, foreign_key: true
      t.references :input, foreign_key: true

      t.timestamps
    end

    create_table :transactions do |t|
      t.string :transaction_type
      t.text :notes
      t.timestamp :transaction_date
      t.references :purchase_order, foreign_key: true
      t.references :inventory, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

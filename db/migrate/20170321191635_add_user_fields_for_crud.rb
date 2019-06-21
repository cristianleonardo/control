class AddUserFieldsForCrud < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :active, :boolean, default: false
    add_column :users, :disabled, :boolean, default: false
    add_column :users, :contact_phone, :string
    add_column :users, :invitation_token, :string
    add_column :users, :invitation_sent_at, :datetime
    add_column :users, :role, :string
    remove_column :users, :identification
  end
end

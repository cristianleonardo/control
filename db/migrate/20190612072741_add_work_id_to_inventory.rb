class AddWorkIdToInventory < ActiveRecord::Migration[5.0]
  def change
  	add_reference :inventories, :work, index: true
  end
end

class AddApprovedToCustomer < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :approved, :boolean
  end
end

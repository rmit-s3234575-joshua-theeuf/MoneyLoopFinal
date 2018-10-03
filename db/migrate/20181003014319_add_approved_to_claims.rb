class AddApprovedToClaims < ActiveRecord::Migration[5.0]
  def change
    add_column :claims, :approved, :boolean
  end
end

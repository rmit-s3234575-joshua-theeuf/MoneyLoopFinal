class AddDetailsToClaims < ActiveRecord::Migration[5.0]
  def change
    add_column :claims, :customer_id, :string
    add_column :claims, :company_id, :string
    add_column :claims, :exposure, :string
    add_column :claims, :date_of_origination, :string
    add_column :claims, :credit_score, :string
  end
end

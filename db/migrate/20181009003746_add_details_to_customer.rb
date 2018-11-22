class AddDetailsToCustomer < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :exposure, :string
    add_column :customers, :date_of_origination, :string
  end
end

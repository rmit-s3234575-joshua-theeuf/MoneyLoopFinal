class AddCompanyIdToCustomer < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :company_id, :string
  end
end

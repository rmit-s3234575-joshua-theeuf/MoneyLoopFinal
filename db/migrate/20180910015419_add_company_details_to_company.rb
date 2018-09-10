class AddCompanyDetailsToCompany < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :name, :string
    add_column :companies, :abn, :string
    add_column :companies, :tfn, :string
    add_column :companies, :acn, :string
    add_column :companies, :contact_number, :string
    add_column :companies, :contact_email, :string
    add_column :companies, :type, :string
  end
end

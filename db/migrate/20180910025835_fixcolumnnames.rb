class Fixcolumnnames < ActiveRecord::Migration[5.0]
  def change
	rename_column :companies, :type, :company_type
  end
end

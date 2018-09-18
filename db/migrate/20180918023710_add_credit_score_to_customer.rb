class AddCreditScoreToCustomer < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :credit_score, :string
  end
end

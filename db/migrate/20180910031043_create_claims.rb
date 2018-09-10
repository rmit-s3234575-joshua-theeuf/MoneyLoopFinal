class CreateClaims < ActiveRecord::Migration[5.0]
  def change
    create_table :claims do |t|

      t.timestamps
    end
  end
end

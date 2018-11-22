class CreateFailuires < ActiveRecord::Migration[5.0]
  def change
    create_table :failuires do |t|

      t.timestamps
    end
  end
end

class CreateApiKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :api_keys do |t|
      t.string :token
      t.string :service_provider_id

      t.timestamps
    end
  end
end

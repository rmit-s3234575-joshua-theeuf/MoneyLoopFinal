class AddFieldsToCustomer < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :given_names, :string
    add_column :customers, :surname, :string
    add_column :customers, :email, :string
    add_column :customers, :phone_mobile, :string
    add_column :customers, :phone_home, :string
    add_column :customers, :dob, :string
    add_column :customers, :address, :string
    add_column :customers, :employer_name, :string
    add_column :customers, :job_title, :string
    add_column :customers, :device_type, :string
    add_column :customers, :device_os, :string
    add_column :customers, :device_model, :string
    add_column :customers, :device_screen_resolution, :string
    add_column :customers, :network_service_provider, :string
    add_column :customers, :ip_location, :string
    add_column :customers, :time_zone, :string
    add_column :customers, :time_of_day, :string
  end
end

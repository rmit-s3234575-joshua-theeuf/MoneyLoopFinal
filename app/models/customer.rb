class Customer < ApplicationRecord
    validates :given_names,:surname, :email,:phone_mobile, :phone_home,:dob, :address, :employer_name, :job_title,:device_os, :device_type, :device_model, :device_screen_resolution, :ip_location, :time_zone, :presence => true
end

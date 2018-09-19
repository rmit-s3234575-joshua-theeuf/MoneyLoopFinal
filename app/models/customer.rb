class Customer < ApplicationRecord
    validates :given_names,:surname, :email,:phone_mobile, :phone_home,:dob, :address, :employer_name, :job_title,:device_os, :device_type, :device_model, :device_screen_resolution, :ip_location, :time_zone, :presence => true
    before_save :sanitize
    def sanitize
      self.given_names.downcase!
      self.surname.downcase!
      self.email.downcase!
      self.phone_home.downcase!
      self.phone_mobile.downcase!
      self.dob= self.dob.to_date.strftime("%d%m%Y")
      self.address.downcase!
      self.employer_name.downcase!
      self.job_title.downcase!
      self.device_os.downcase!
      self.device_type.downcase!
      self.device_model.downcase!
      self.device_screen_resolution.downcase!
      self.time_zone.downcase!
      self.time_of_day.downcase!
    end
end

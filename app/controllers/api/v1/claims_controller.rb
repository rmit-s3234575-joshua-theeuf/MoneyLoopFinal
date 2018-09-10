class Api::V1::ClaimsController < ApplicationController
  def index
  end

  def show
  end

  def create
  end

  def destroy
  end

  def update
  end

  private
  def claims_params
      params.permit(:given_name, :surname, :email, :phone_mobile, :phone_home,:dob, :address, :employer_name, :job_title, :device_type, :device_os, :device_model, :device_screen_resolution, :ip_location, :time_zone, :time_of_day, :company_id)
  end
end

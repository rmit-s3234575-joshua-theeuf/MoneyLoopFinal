class Api::V1::CustomersController < ApplicationController
  def index
    customer = Customer.all
    render json: {status: "Success", message: "Customer Details", data: customer}, status: :ok
  end

  def new
  end

  def show
  end

  def update
  end

  def destroy
  end

  def edit
  end

  private
  def customer_params
    params.permit(:given_name, :surname, :email, :phone_mobile, :phone_home,:dob, :address, :employer_name, :job_title, :device_type, :device_os, :device_model, :device_screen_resolution, :ip_location, :time_zone, :time_of_day, :company_id)
  end
end

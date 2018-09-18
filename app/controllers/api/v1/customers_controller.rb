class Api::V1::CustomersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :restrict_access
  def index
    customer = Customer.all
    render json: {status: "Success", message: "Customer Details", data: customer}, status: :ok
  end

  def create
    customer = Customer.new(customer_params)
    #create a customer.
    byebug
    customer.company_id = ApiKey.find_by(token: params[token]).service_provider_id
    if customer.save
      render json: {status: "Success", message: "Created", data:customer}, status: :ok
    else
      render json: {status: "failed", message: "failed to create object", data:customer.errors}, status: :unprocessable_entity
    end
  end

  def show
    begin
      customer = Customer.find(params[:id])
      render json: {status: "Success", message: "loaded insureance details", data:customer}, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: {status: "Failed", message: "Object not found where id = #{params[:id]}"}, status: :unprocessable_entity
    end
  end

  def update
    begin
      customer = Customer.find(params[:id])
      if customer.update_attributes(customer_params)
        render json: {status: "Success", message: "updated", data:customer}, status: :ok
      else
        render json: {status: "failed", message: "failed to update", data:customer.errors}, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: {status: "failed", message: "failed to find object where id = #{params[:id]}"}, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      customer = Customer.find(params[:id])
      customer.destroy
      render json: {status: "Success", message: "Succesfully destroyed"}, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: {status: "failed", message: "failed to destroy object where id = #{params[:id]}"}, status: :unprocessable_entity
    end
  end

  private
  def customer_params
    params.permit(:given_name, :surname, :email, :phone_mobile, :phone_home,:dob, :address, :employer_name, :job_title, :device_type, :device_os, :device_model, :device_screen_resolution, :ip_location, :time_zone, :time_of_day, :company_id)
  end
  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      byebug
      if ApiKey.exists?(:token => "#{token}")
        params[:service_provider] = ApiKey.find_by(:token => "#{token}").service_provider_id
      end
    end

  end
end

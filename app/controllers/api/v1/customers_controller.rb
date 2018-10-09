class Api::V1::CustomersController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'
  skip_before_action :verify_authenticity_token
  before_action :restrict_access
  def index
    customer = Customer.all.where(company_id: params[:company_id])
    render json: {status: "Success", message: "Customer Details", data: customer}, status: :ok
  end

  def create
    customer = Customer.new(customer_params)

    #create a customer.
    customer.update(dob:customer_params[:dob].to_date.strftime("%d%m%Y"))
    if customer.save
      claim = Claim.new(:customer_id => customer.id, :company_id => customer.company_id, :exposure => customer.exposure, :date_of_origination => customer.date_of_origination)
      if claim.save
        if calculate_credit_score(customer, claim)
        claim.save
        customer.save
        byebug
        render json: {status: "Success", message: "Created", data:{"claim": claim, "customer":customer}}, status: :ok
      else
        render json: {status: "Failed", message: "Failed to generate claim and customer. See json body for error message. ", data: $content[:body]}, status: :unprocessable_entity
      end
      else
        render json: {status: "failed", message: "failed to create object", data:customer.errors}, status: :unprocessable_entity
      end
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
      customer = Customer.find(params[:id]).where(company_id: params[:company_id])
      customer.destroy
      render json: {status: "Success", message: "Succesfully destroyed"}, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: {status: "failed", message: "failed to destroy object where id = #{params[:id]}"}, status: :unprocessable_entity
    end
  end

  private
  def customer_params
    params.permit(:given_names, :surname, :email, :phone_mobile, :phone_home,:dob, :address, :employer_name, :job_title, :device_type, :device_os, :device_model, :device_screen_resolution, :ip_location,:network_service_provider, :time_zone, :time_of_day, :company_id, :approved, :exposure, :date_of_origination)
  end
  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      if ApiKey.exists?(:token => "#{token}")
        params[:company_id] = ApiKey.find_by(:token => "#{token}").service_provider_id
      end
    end
  end
  #this is where we will intereact with the infrenetics credit model.
  def calculate_credit_score(customer, claim)
    uri = URI.parse("https://api.inferentics.com/v1")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Token test_1825b34257c8398b035c110edd03b0911353c0d5155f7ee5d3738467b6"
    request.body = JSON.dump({
      "exposure" => claim.exposure,
      "given_names" => "#{customer.given_names}",
      "surname" => "#{customer.surname}",
      "email" => "#{customer.email}",
      "phone_mobile" => "#{customer.phone_mobile}",
      "phone_home" => "#{customer.phone_home}",
      "dob" => "#{customer.dob}",
      "address" => "#{customer.address}",
      "employer_name" => "#{customer.employer_name}",
      "job_title" => "#{customer.job_title}",
      "device_type" => "#{customer.device_type}",
      "device_os" => "#{customer.device_os}",
      "device_model" => "#{customer.device_model}",
      "device_screen_resolution" => "#{customer.device_screen_resolution}",
      "network_service_provider" => "#{customer.network_service_provider}",
      "ip_address" => "#{customer.ip_location}",
      "time_zone" => "#{customer.time_zone}",
      "time_of_day" => "#{customer.time_of_day}"
      })

      req_options = {
        use_ssl: uri.scheme == "https",
      }
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
      response.code
      response.body
      byebug
      $content = {code: JSON.parse(response.code), body: JSON.parse(response.body)}
      if $content[:code] != 200
        return false
      end
      credit_score = JSON.parse(response.body)
      #business rules for approval and rejection
      if customer.update(credit_score: credit_score["result"])
        byebug
        customer.save
        if credit_score['result'].to_i >= 750
          claim.approved = true
          customer.approved = true
          claim.credit_score = credit_score['result']
        else
          claim.approved = false
          customer.approved = true
          claim.credit_score = credit_score['result']
        end
        return
      end
    end
  end

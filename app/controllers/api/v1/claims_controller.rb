class Api::V1::ClaimsController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'
  skip_before_action :verify_authenticity_token
  before_action :restrict_access
  def index
    claim = Claim.all
    render json: {status: "Success", message: "Claim Details", data: claim}, status: :ok
  end

  def show
    begin
      claim = Claim.where(customer_id: params[:id])
      render json: {status: "Success", message: "Claim Details", data:claim}, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: {status: "Failed", message: "Object not found where id = #{params[:id]}"}, status: :unprocessable_entity
    end
  end

  def create
    claim  = Claim.new(claims_params)
    claim.company_id = params[:company_id]
    customer = Customer.find_by(id: claims_params[:customer_id])
    #create a claim.
    # byebug
    if Company.exists?(id: claim.company_id)
      if Customer.exists?(id: claim.customer_id) && customer.company_id == params[:company_id]
        claculate_credit_score(Customer.find_by(id: claim.customer_id), claim)
        if claim.save
          render json: {status: "Success", message: "Created", data:claim}, status: :ok
        else
          render json: {status: "failed", message: "failed to create object", data:claim.errors}, status: :unprocessable_entity
        end
      else
        render json: {status: "failed", message: "Customer not found"}, status: :unprocessable_entity
      end
    else
      render json: {status: "failed", message: "Company not found"}, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      claim = Claim.find(claim_params[:id])
      claim.destroy
      render json: {status: "Success", message: "Succesfully destroyed"}, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: {status: "failed", message: "failed to destroy object where id = #{params[:id]}"}, status: :unprocessable_entity
    end
  end

  def update
    begin
      claim = Claim.find(params[:id])
      if claim.update_attributes(claims_params)
        render json: {status: "Success", message: "updated", data:claim}, status: :ok
      else
        render json: {status: "failed", message: "failed to update", data:claim.errors}, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: {status: "failed", message: "failed to find object where id = #{params[:id]}"}, status: :unprocessable_entity
    end
  end

  private
  def claims_params
    params.permit( :customer_id, :exposure, :date_of_origination)
  end
  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      if ApiKey.exists?(:token => "#{token}")
        params[:company_id] = ApiKey.find_by(:token => "#{token}").service_provider_id
      end
    end
  end
  public
  #this is where we will intereact with the infrenetics credit model.
  def claculate_credit_score(customer, claim)
    byebug
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
      credit_score = JSON.parse(response.body)
      #business rules for approval and rejection
      if customer.update(credit_score: credit_score["result"])
        if credit_score['result'].to_i >= 750
          claim.approved = true
        else
          claim.approved = false
        end
        return
      end
    end

  end

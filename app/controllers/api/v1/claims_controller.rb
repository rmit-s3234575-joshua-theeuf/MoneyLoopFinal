class Api::V1::ClaimsController < ApplicationController
  require 'net/http'
  skip_before_action :verify_authenticity_token
  before_action :restrict_access
  def index
    claim = Claim.all
    render json: {status: "Success", message: "Claim Details", data: claim}, status: :ok
  end

  def show
    begin
      claim = Claim.find(params[:id])
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

  #this is where we will intereact with the infrenetics credit model.
  def claculate_credit_score(customer, claim)

    hash = JSON(customer.to_json)
    hash.delete("credit_score")
    hash.delete('id')
    hash.delete('created_at')
    hash.delete('updated_at')
    hash["exposure"] = claim.exposure
    uri = URI.parse('https://api.inferentics.com/v1')
    maps = {"exposure"=>'500', "given_names"=>"John", "surname"=>"Smith", "email"=>"john.smith@example.com", "phone_mobile"=>"+61400123123", "phone_home"=>"+61298001234", "dob"=>"01011900", "address"=>"Level 2 11 York St Sydney NSW 2000", "employer_name"=>"Test Company", "job_title"=>"job title", "device_type"=>"mobile",
       "device_os"=>"windows", "device_model"=>"Samsung SM-G930F Galaxy S7", "device_screen_resolution"=>"412x732", "network_service_provider"=>"telstra", "ip_location"=> {"latitude"=>"-33.8145", "longitude"=>"151.0375"}, "time_zone"=>"+1000", "time_of_day"=>"23:52"}
    request["application/json"]
    request["authorization"]= "Token test_1825b34257c8398b035c110edd03b0911353c0d5155f7ee5d3738467b6"
    request.body = maps
        byebug
    res = Net::HTTP.post_form(uri,maps)
    puts res.body
  end

  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      if ApiKey.exists?(:token => "#{token}")
        params[:company_id] = ApiKey.find_by(:token => "#{token}").service_provider_id
      end
    end
  end
end

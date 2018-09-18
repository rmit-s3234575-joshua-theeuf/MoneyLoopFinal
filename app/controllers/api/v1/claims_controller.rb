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
    byebug
    hash = JSON(customer.to_json)
    hash.delete("credit_score")
    hash.delete('id')
    hash.delete('created_at')
    hash.delete('updated_at')
    hash["exposure"] = claim.exposure
    hash['head']
    uri = URI.parse('https://api.inferentics.com/v1')
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request["User-Agent"] = "My Ruby Script"
    request["Accept"] = "*/*"
    request["authorization"]= "Token test_1825b34257c8398b035c110edd03b0911353c0d5155f7ee5d3738467b6"
    res = http.request(request)
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

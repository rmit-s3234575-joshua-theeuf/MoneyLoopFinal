class CompaniesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
  end

  def create
        company = Company.new(company_params)
        if company.save
          api_token = SecureRandom.hex(16)
          test_token = SecureRandom.hex(16)
          ApiKey.create(token: api_token, service_provider_id: company.id)
          render json: {status: "Success", message: "Created", data:api_token}, status: :ok
        else
          render json: {status: "failed", message: "failed to create object", data:company.errors}, status: :unprocessable_entity
        end
  end

  def show
    begin
      company = Company.find(params[:id])
      render json: {status: "Success", message: "loaded insureance details", data:company}, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: {status: "Failed", message: "Object not found where id = #{params[:id]}"}, status: :unprocessable_entity
    end
  end

  def update
  end

  def destroy
    begin
      company = Company.find(params[:id])
      company.destroy
      render json: {status: "Success", message: "Succesfully destroyed"}, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: {status: "failed", message: "failed to destroy object where id = #{params[:id]}"}, status: :unprocessable_entity
    end
  end

  private
  #name is the company name, abn is the Australian business number, tfn is the taxfile number, type is what type of insurance product do they offer.
  #i.e. 1. Excess paid to insurer, 2. Co-Payment
  def company_params
    params.permit(:name, :abn, :acn, :tfn, :contact_number, :contact_email, :company_type)
  end
end

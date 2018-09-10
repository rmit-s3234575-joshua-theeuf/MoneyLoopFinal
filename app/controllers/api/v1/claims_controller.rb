class Api::V1::ClaimsController < ApplicationController
  skip_before_action :verify_authenticity_token
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
    #create a claim.
    if Company.exists?(id: claim.company_id)
      if Customer.exists?(id: claim.customer_id)
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
      claim = Claim.find(params[:id])
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
    params.permit(:company_id, :customer_id, :exposure, :date_of_origination, :credit_score)
  end

  #this is where we will intereact with the infrenetics credit model.
  def claculate_credit_score
  end
end

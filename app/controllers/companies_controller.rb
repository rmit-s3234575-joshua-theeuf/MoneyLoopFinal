class Api::V1::CompaniesController < ApplicationController
  def index
  end

  def create
  end

  def show
  end

  def update
  end

  def destroy
  end

  private
  #name is the company name, abn is the Australian business number, tfn is the taxfile number, type is what type of insurance product do they offer.
  #i.e. 1. Excess paid to insurer, 2. Co-Payment
  def company_params
    params.permit(:name, :abn, :acn, :tfn, :contact_number, :contact_email, :type)
  end
end

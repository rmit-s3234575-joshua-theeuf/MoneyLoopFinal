class FailuiresController < ApplicationController
  before_action :set_failuire, only: [:show, :edit, :update, :destroy]

  # GET /failuires
  # GET /failuires.json
  def index
    @failuires = Failuire.all
  end

  # GET /failuires/1
  # GET /failuires/1.json
  def show
  end

  # GET /failuires/new
  def new
    @failuire = Failuire.new
  end

  # GET /failuires/1/edit
  def edit
  end

  # POST /failuires
  # POST /failuires.json
  def create
    @failuire = Failuire.new(failuire_params)

    respond_to do |format|
      if @failuire.save
        format.html { redirect_to @failuire, notice: 'Failuire was successfully created.' }
        format.json { render :show, status: :created, location: @failuire }
      else
        format.html { render :new }
        format.json { render json: @failuire.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /failuires/1
  # PATCH/PUT /failuires/1.json
  def update
    respond_to do |format|
      if @failuire.update(failuire_params)
        format.html { redirect_to @failuire, notice: 'Failuire was successfully updated.' }
        format.json { render :show, status: :ok, location: @failuire }
      else
        format.html { render :edit }
        format.json { render json: @failuire.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /failuires/1
  # DELETE /failuires/1.json
  def destroy
    @failuire.destroy
    respond_to do |format|
      format.html { redirect_to failuires_url, notice: 'Failuire was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_failuire
      @failuire = Failuire.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def failuire_params
      params.fetch(:failuire, {})
    end
end

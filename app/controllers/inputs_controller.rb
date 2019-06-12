class InputsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_input, only: [:edit, :update, :destroy]
  def index
    @inputs = Input.all
  end

  def new
    @input = Input.new
  end

  def edit
  end

  def create

    @input = Input.new(input_params)
    respond_to do |format|
      if @input.save
        format.html { redirect_to inputs_path, notice: 'El registro se realizo correctamente.' }
      else
       format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @input.update(input_params)
        format.html { redirect_to inputs_path, notice: 'El registro se realizo correctamente.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @input.destroy
    respond_to do |format|
      format.html { redirect_to inputs_path, notice: 'La adición fue eliminada exitosamente.' }
    end
  end

  private

  def set_input
    @input = Input.find(params[:id])
  end

  def input_params
    params.require(:input).permit(
      :name,
      :abbrevation,
      :input_type,
      :metrics,
      :description,
      provider_ids: []
    )
  end
end

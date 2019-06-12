class WorkTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_work_type, only: [:edit, :update, :destroy]

  def index
    @work_types = WorkType.all
    authorize @work_types
  end

  def new
    @work_type = WorkType.new
    authorize @work_type
  end

  def edit
    authorize @work_type
  end

  def create
    @work_type = WorkType.new(work_type_params)
    authorize @work_type

    respond_to do |format|
      if @work_type.save
        format.html { redirect_to work_types_path, notice: 'El tipo de obra fue creada exitosamente.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    authorize @work_type

    respond_to do |format|
      if @work_type.update(work_type_params)
        format.html { redirect_to work_types_path, notice: 'El tipo de obra fue actualizada exitosamente.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    authorize @work_type
    @work_type.destroy
    respond_to do |format|
      format.html { redirect_to work_types_url, notice: 'El tipo de obra fue eliminada exitosamente.' }
    end
  end

  private

  def set_work_type
    @work_type = WorkType.find(params[:id])
  end

  def work_type_params
    params.require(:work_type).permit(:abbreviation, :name)
  end
end

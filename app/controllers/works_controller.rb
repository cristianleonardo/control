class WorksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_work, only: [:edit, :update, :destroy]
  def index
    @works = Work.all
  end

  def new
    @work = Work.new
  end

  def edit
  end

  def create
    @work = Work.new(work_params)
    respond_to do |format|
      if @work.save
        format.html { redirect_to works_path, notice: 'El registro se realizo correctamente.' }
      else
       format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @work.update(work_params)
        format.html { redirect_to works_path, notice: 'El registro se realizo correctamente.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @work.destroy
    respond_to do |format|
      format.html { redirect_to works_path, notice: 'La obra fue eliminada exitosamente.' }
    end
  end

  private

  def set_work
    @work = Work.find(params[:id])
  end

  def work_params
    params.require(:work).permit(
      :number,
      :description,
      :budget,
      :work_type_id
    )
  end
end

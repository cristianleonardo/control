class SourcesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_source, only: [:edit, :show, :update, :destroy]
  before_action :set_current_query, only: [:edit, :show, :new]
  before_action :set_current_page, only: [:edit, :show, :new]

  def index
    @sources = Source.search(params[:query]).order(:name).page params[:page]
    authorize @sources
  end

  def new
    @source = Source.new
    authorize @source
  end

  def edit
    @current_page = params[:page]
    authorize @source
  end

  def show
    authorize @source
  end

  def create
    @source = Source.new(source_params)
    authorize @source

    # general_source_type
    # gst = GeneralSource.find(@source.general_source_id).general_source_type
    # @source.source_type = (gst == 'pgei') ? :paei : :rp

    respond_to do |format|
      if @source.save
        format.html { redirect_to sources_path(query: params[:query], page: params[:page]), notice: 'La fuente fue creada exitosamente.' }
      else
       format.html { render :new }
      end
    end
  end

  def update
    authorize @source
    respond_to do |format|
      if @source.update(source_params)
        format.html { redirect_to sources_path(query: params[:query], page: params[:page]), notice: 'La fuente fue actualizada exitosamente.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    authorize @source
    @source.destroy
    respond_to do |format|
      if @source.errors.details.empty?
        format.html { redirect_to sources_path(query: params[:query], page: params[:page]), notice: 'La fuente fue eliminada exitosamente.' }
      end
      format.html { redirect_to sources_path(query: params[:query], page: params[:page]), alert: "La fuente #{@source.name} no puede ser eliminada porque ya tiene recursos reservados"}
    end
  end

  private

  def set_current_page
    @current_page = params[:page]
  end

  def set_current_query
    @current_query = params[:query]
  end

  def set_source
    @source = Source.find(params[:id])
  end

  def source_params
    params.require(:source).permit(:name, :description, :source_type)
  end
end

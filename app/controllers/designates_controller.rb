class DesignatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_certificate
  before_action :set_designate, only: [:edit, :update, :destroy]
  before_action :set_current_query, only: [:edit, :new, :index]
  before_action :set_current_page, only: [:edit, :index, :new]

  def index
    @designates = @certificate.designates.includes(:source)
    authorize @designates
  end

  def new
    @designate = @certificate.designates.new
    authorize @designate
  end

  def edit
    authorize @designate
  end

  # TODO: method too big
  def create
    @designate = @certificate.designates.new(designate_params)
    authorize @designate

    @designate.certificate_id = @certificate.id
    @designate.value = 0

    respond_to do |format|
      if @designate.save
        format.html { redirect_to edit_certificate_designate_path(@certificate, @designate, query: params[:query], page: params[:page]), notice: 'La fuente fue creada exitosamente.' }
      else
        format.html { redirect_to certificate_designates_path(@certificate), alert: @designate.errors.messages[:source][0] + ' - Fuente: ' + @designate.source.name }
      end
    end
  end

  def update
    authorize @designate

    respond_to do |format|
      if @designate.update(designate_params)
        format.html { redirect_to certificate_designates_path(@certificate, query: params[:query], page: params[:page]), notice: 'La  fuente fue actualizada exitosamente.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    authorize @designate
    @designate.destroy

    respond_to do |format|
      if @designate.errors.details.empty?
        format.html { redirect_to certificate_designates_path(@certificate, query: params[:query], page: params[:page]), notice: 'La fuente fue eliminada exitosamente.' }
      end
      format.html { redirect_to certificate_designates_path(@certificate, query: params[:query], page: params[:page]), alert: "La fuente #{@designate.source.name} para el certificado #{@certificate.number} no puede ser eliminada porque ya tiene presupuesto asignado"}
    end
  end

  private

  def default_url_options(options={})
    { query: params[:query], query1: params[:query1], query2: params[:query2], query3: params[:query3] }
  end

  def set_current_page
    @current_page = params[:page]
  end

  def set_current_query
    @current_query = params[:query]
  end

  def set_certificate
    @certificate = Certificate.find(params[:certificate_id])
  end

  def set_designate
    @designate = Designate.find(params[:id])
  end

  def designate_params
    params.require(:designate).permit(:value, :source_id, :total_release, :query)
  end
end

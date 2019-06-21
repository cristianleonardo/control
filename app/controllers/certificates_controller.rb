class CertificatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_certificate, only: [:show, :edit, :update, :destroy]
  before_action :set_current_page, only: [:edit, :show, :new]

  def index
    unless session[:certificates_hash].blank?
      @certificates = Certificate.certificates_search(session[:certificates_hash]).order(:initial_date).page(params[:page])
    else
      @certificates = Certificate.includes(:budgets).order(:number).page(params[:page])
    end
    authorize @certificates
  end

  def new
    @certificate = Certificate.new
    authorize @certificate
  end

  def edit
    authorize @certificate
  end

  def show
    authorize @certificate
  end

  def create
    @certificate = Certificate.new(certificate_params)
    authorize @certificate

    respond_to do |format|
      if @certificate.save
        format.html { redirect_to certificates_path(page: params[:page]), notice: 'El certificado fue creado exitosamente.' }
      else
        format.html { redirect_to new_certificates_path(page: params[:page]), alert: @certificate.errors.messages[:documents][0] }
      end
    end
  end

  def update
    authorize @certificate

    respond_to do |format|
      if @certificate.update(certificate_params)
        format.html { redirect_to certificates_path( page: params[:page]), notice: 'El certificado fue actualizado exitosamente.' }
      else
        format.html {  render :edit }
      end
    end
  end

  def destroy
    authorize @certificate
    @certificate.destroy

    respond_to do |format|
      if @certificate.errors.details.empty?
        format.html { redirect_to certificates_url( page: params[:page]), notice: 'El certificado fue eliminado exitosamente.' }
      else
        format.html { redirect_to certificates_path( page: params[:page]), alert: "El certificado #{@certificate.number} no puede ser eliminado porque ya tiene fuentes asignadas"}
      end
    end
  end

  def report
    @certificates = Certificate.certificates_search(session[:certificates_hash])

    respond_to do |format|
      format.xlsx{
        response.headers['Content-Disposition'] = 'attachment; filename="certificados_reporte.xlsx"'
      }
    end
  end

  def search
    session[:certificates_hash] = search_params
    redirect_to certificates_path
  end

  def clean
    session[:certificates_hash] = {}
    redirect_to certificates_path
  end

  private

  def search_params

    params.permit(:keyword, :st_date, :ed_date, :committee_minute_id, :avaiability_letter_id,
                  :sub_component_id, :state, :certificate_type, :available_value, :component_id, :annual_budget_id, source_id: []).delete_if {|key, value| value.blank?}

  end

  def set_current_page
    @current_page = params[:page]
  end

  def set_certificate
    @certificate = Certificate.find(params[:id])
  end

  def certificate_params
    params.require(:certificate).permit(
      :number,
      :expense_concept,
      :initial_date,
      :limit_date,
      :project_name,
      :state,
      :sub_component_id,
      :component_id,
      :certificate_type,
      :committee_minute_id,
      :avaiability_letter_id,
      :annual_budget_id
     )
  end
end

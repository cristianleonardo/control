class ContractorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contractor, only: [:edit, :show, :update, :destroy]
  before_action :set_current_query, only: [:edit, :show, :new]
  before_action :set_current_page, only: [:edit, :show, :new]

  def index
    unless params[:query]
      @contractors = Contractor.page(params[:page]).order(:name)
    else
      @contractors = Contractor.basic_search(params[:query]).page(params[:page]).order(:name)
    end
    authorize @contractors
  end

  def new
    @contractor = Contractor.new
    authorize @contractor
  end

  def edit
    authorize @contractor
  end

  def show
    authorize @contractor
  end

  def create
    @contractor = Contractor.new(contractor_params)
    authorize @contractor

    # TODO: Refactor
    if @contractor.contractor_type_id == 2
      @contractor.legal_representant_name = @contractor.name
      @contractor.legal_representant_document_number = @contractor.document_number
      @contractor.legal_representant_document_type = @contractor.document_type
    end

    respond_to do |format|
      if @contractor.save
        format.html { redirect_to contractors_path(query: params[:query], page: params[:page]), notice: 'El contrato fue creado exitosamente.' }
      else
       format.html { render :new }
      end
    end
  end

  def update
    authorize @contractor

    respond_to do |format|
      if @contractor.update(contractor_params)
        # TODO: Refactor
        if @contractor.contractor_type_id == 2
          @contractor.update_attributes(
            legal_representant_name: @contractor.name,
            legal_representant_document_number: @contractor.document_number,
            legal_representant_document_type: @contractor.document_type
          )
        end

        format.html { redirect_to contractors_path(query: params[:query], page: params[:page]), notice: 'El contrato fue actualizado exitosamente.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    authorize @contractor
    @contractor.destroy

    respond_to do |format|
      format.html { redirect_to contractors_url(query: params[:query], page: params[:page]), notice: 'El contrato fue eliminado exitosamente.' }
    end
  end

  private

  def set_current_page
    @current_page = params[:page]
  end

  def set_current_query
    @current_query = params[:query]
  end

  def set_contractor
    @contractor = Contractor.find(params[:id])
  end

  def contractor_params
    params.require(:contractor).permit( :name,
     :document_number,
     :document_type,
     :legal_representant_name,
     :legal_representant_document_number,
     :legal_representant_document_type,
     :contractor_type_id)
  end
end

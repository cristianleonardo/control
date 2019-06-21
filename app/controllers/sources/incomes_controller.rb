module Sources
  class IncomesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_source
    before_action :set_income, only: [:edit, :update, :destroy]
    before_action :set_current_query, only: [:edit, :index, :new]
    before_action :set_current_page, only: [:edit, :index, :new]

    def index
      @incomes = @source.incomes.order(income_date: :desc)
      # authorize @incomes
    end

    def new
      @income = @source.incomes.new
      # authorize @income
    end

    def edit
      # authorize @income
    end

    def create
      @income = @source.incomes.new(income_params)
      # authorize @income
      respond_to do |format|
        # if (@source.total_value + @income.income_value) > (@source.general_source.total_value)
        #   format.html { redirect_to source_incomes_path(@source), alert: "El ingreso supera el valor permitido por la fuente general #{@source.general_source.name}." }
        # else
          if @income.save
            format.html { redirect_to source_incomes_path(@source, query: params[:query], page: params[:page]), notice: 'El ingreso fue creado exitosamente.' }
          else
            format.html { render :new }
          end
        # end
      end
    end

    def update
      # authorize @income

      respond_to do |format|
        if @income.update(income_params)
          format.html { redirect_to source_incomes_path(@source, query: params[:query], page: params[:page]), notice: 'El ingreso fue actualizado exitosamente.' }
        else
          format.html { render :edit }
        end
      end
    end

    def destroy
      # authorize @income
      @income.destroy

      respond_to do |format|
        format.html { redirect_to source_incomes_path(@source, query: params[:query], page: params[:page]), notice: 'El ignreso fue eliminado exitosamente.' }
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
      @source = Source.find(params[:source_id])
    end

    def set_income
      @income = Income.find(params[:id])
    end

    def income_params
      params.require(:income).permit(:code, :description, :income_date, :income_value, :incomeable_id, :incomeable_type, :financial_return, :component_id, :sub_component_id)
    end
  end
end

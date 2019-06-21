class StrategicPlanningController < ApplicationController
  before_action :authenticate_user!
  before_action :set_components, only: [:index]
  before_action :set_sources, only: [:index]
  caches_action :index, :if => Proc.new { params[:query1].nil? }

  def index
    if params[:query1] || params[:query2]
      default_date = Income.all.order(:income_date).first.income_date
      starting_date = params[:query1] && params[:query1] != '' ? Date.parse(params[:query1]) : default_date
      ending_date = params[:query2] && params[:query2] != '' ? Date.parse(params[:query2]) : Date.today

      @certificates = Certificate.where(initial_date: starting_date..ending_date)
      @payments = Payment.where(date: starting_date..ending_date)
    else
      @certificates = Certificate.all
      @payments = Payment.all
    end

  end

  def show
  end

  private

  def set_components
    @components = Component.pluck(:name)
    @components_id = Component.pluck(:id)
  end

  def set_sources
    @sources = Source.where('name NOT LIKE ?','%MUNICIPIO%').pluck(:name)
    @sources.push("RECURSOS MUNICIPIO")
    sources = []
    @sources.each do |source|
      unless source.include?("MUNICIPIO")|| source.include?("DE LA NACION")
        tmp = source.delete_prefix("RECURSOS REGALÍAS SGR ").delete_prefix("RECURSOS").delete_prefix("-")
        sources.push(tmp)
      else
        sources.push(source)
      end
    end
    @sources = sources
  end
end

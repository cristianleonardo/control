class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index; end

  def sources_chart
    render json: [total_sources_available('paei'), total_sources_reserved('paei'), total_sources_assigned('paei'), total_expended_value('paei')]
  end

  def rp_sources_chart
    render json: [total_sources_available('rp'), total_sources_reserved('rp'), total_sources_assigned('rp'), total_expended_value('rp')]
  end

  def total_sources_available(source_type)
    total = 0
    sources = Source.where(source_type: source_type)
    sources.each do |source|
      total += source.available_value
    end
    total
  end

  def total_sources_reserved(source_type)
    total_designated_value(source_type) - total_funded_value(source_type)
  end

  def total_sources_assigned(source_type)
    total_funded_value(source_type) - total_expended_value(source_type)
  end

  def total_designated_value(source_type)
    total = 0
    sql = "INNER JOIN sources ON designates.source_id = sources.id"
    designates = Designate.joins(sql).where(sources: {source_type: source_type })
    designates.each do |designate|
      total += designate.value
    end
    total
  end

  def total_funded_value(source_type)
    total = 0
    sql = "INNER JOIN designates ON funds.designate_id = designates.id JOIN sources ON sources.id = designates.source_id"
    funds = Fund.joins(sql).where(sources: {source_type: source_type})
    funds.each do |fund|
      total += fund.value
    end
    total
  end

  def total_expended_value(source_type)
    total = 0
    sql = "INNER JOIN funds ON expenditures.fund_id = funds.id JOIN designates ON funds.designate_id = designates.id JOIN sources ON sources.id = designates.source_id"
    expenditures = Expenditure.joins(sql).where(sources: {source_type: source_type})
    expenditures.each do |expenditure|
      total += expenditure.value
    end
    total
  end

end

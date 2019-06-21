module DesignatesHelper
  def source_value_hash(certificate)
    sources_value = {}
    if certificate.certificate_type == 'CDP'
      source_type = 'rp'
    else
      source_type = 're'
    end
    not_available_sources = Designate.where(certificate_id: certificate.id).pluck(:source_id)
    Source.where(source_type: source_type).where.not(id: not_available_sources).each do |source|
      sources_value[source.id] = "#{source.name} - Valor disponible: #{number_to_currency(source.available_value)}"
    end
    sources_value
  end

  def source_available(designate_id)
    @designate = Designate.find(designate_id)
    @designate.source_available_value
  end

  def total_designates_value(designates)
    designates.first.certificate.total_value
  end

  def available_designates_value(designates)
    designates.first.certificate.available_value
  end

  def out_of_limit_check(transaction)
    transaction.out_of_limit_value.present? && transaction.out_of_limit_value.abs > 0
  end
end

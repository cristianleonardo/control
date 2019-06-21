module CertificatesHelper
  def fetch_components_hash
    components = {}
    Component.all.each do |comp|
      components[comp.id] = "#{comp.code} - #{comp.name}"
    end
    components
  end

  def certificates_report
    certificates_data = []
    key_hash = [:number, :certificate_type, :expense_concept, :project_name, :state]
    hash_dates = [:initial_date, :limit_date]
    @certificates.each do |certificate|
      data = []
      
      key_hash.each do |key|
        data.push(certificate[key])
      end

      hash_dates.each do |key|
        data.push(certificate[key] ? certificate[key].strftime("%Y-%m-%d") : '')
      end

      sub_component = SubComponent.find(certificate.sub_component_id)
      sources = certificate.sources.pluck(:name).join(", ")

      data.push(sub_component.name)
      data.push(sources)
      data.push(certificate.total_value)
      data.push(certificate.available_value)

      certificates_data.push(data)
    end
    certificates_data
  end
end

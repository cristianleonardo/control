require 'webpack'

module ApplicationHelper
  def javascript_webpack_asset(name, options = {})
    Webpack.check! if Rails.env.development?
    javascript_include_tag("/assets/javascripts/#{webpack_file(name)}.js", options)
  end

  def stylesheet_webpack_asset(name, options = {})
    Webpack.check! if Rails.env.development?
    stylesheet_link_tag("/assets/stylesheets/#{webpack_file(name)}.css", options)
  end

  def webpack_file(name)
    use_fingerprint_assets = Rails.env.production? || Rails.env.staging?
    use_fingerprint_assets ? "#{name}-#{ASSET_FINGERPRINT}" : name
  end

  def fw_icon(icon_name, label = nil, size = 'lg')
    capture do
      concat content_tag(:i, nil, class: "fa fa-#{icon_name} fa-#{size} fa-fw")
      concat(" #{label}")
    end
  end

  def fullname(user = nil)
    user = user.nil? ? current_user : user
    "#{user.firstname.mb_chars.downcase.titleize} #{user.lastname.mb_chars.downcase.titleize}"
  end

  def name_sub_component(sub_component_id)
    SubComponent.find_by(id: sub_component_id)? SubComponent.find_by(id: sub_component_id).name : ''
  end

  def strftimef(value, format="%Y/%m/%d")
    begin
      value.strftime(format)
    rescue
      '-'
    end
  end

  def contract_payment_percentage(contract)
    contract.cached_payments_sum_value / contract.initial_value * 100
  end

  def is_indicator_path
    contrl = request.params[:controller]
    action = request.params[:action]

    'active' if "#{contrl}/#{action}" == 'dashboard/index'
  end

  def is_contracts_path
    case request.params[:controller]
    when 'contracts' then 'active'
    when 'budgets' then 'active'
    end
  end

  def is_contract_types_path
    case request.params[:controller]
    when 'contract_types' then 'active'
    end
  end

  # def is_general_sources_path
  #   case request.params[:controller]
  #   when 'general_sources' then 'active'
  #   when 'incomes' then 'active'
  #   end
  # end

  def is_sources_path
    case request.params[:controller]
    when 'sources' then 'active'
    when 'sources/incomes' then 'active'
    end
  end

  def is_strategic_planning_path
    case request.params[:controller]
    when 'strategic_planning' then 'active'
    end
  end

  def is_contractor_path
    case request.params[:controller]
    when 'contractors' then 'active'
    end
  end

  def is_taxes_path
    case request.params[:controller]
    when 'taxes' then 'active'
    end
  end

  def is_contractor_types_path
    case request.params[:controller]
    when 'contractor_types' then 'active'
    end
  end

  def is_certificates_path
    case request.params[:controller]
    when 'certificates' then 'active'
    when 'designates' then 'active'
    end
  end

  def is_payments_path
    case request.params[:controller]
    when 'payments' then 'active'
    end
  end

  def is_reports_path
    case request.params[:controller]
    when 'reports' then 'active'
    end
  end

  def is_annual_budgets_path
    case request.params[:controller]
    when 'annual_budgets' then 'active'
    when 'committee_minutes' then 'active'
    when 'avaiability_letters' then 'active'
    when 'source_annual_budgets' then 'active'
    end
  end

  def is_users_path
    case request.params[:controller]
    when 'users' then 'active'
    end
  end

  def is_paei_components_path
    case request.params[:controller]
    when 'components' then 'active'
    when 'sub_components' then 'active'
    end
  end

  # Navbar
  def set_main_link_active
    controllers = %w[dashboard contracts budgets general_sources sources sources/incomes contractors certificates designates payments reports]
    'active' if controllers.include? request.params[:controller]
  end

  def set_administration_link_active
    controllers = %w(taxes users contract_types contractor_types components sub_components)
    'active' if controllers.include? request.params[:controller]
  end

  def current_year
    Time.zone.today.strftime('%Y')
  end
end

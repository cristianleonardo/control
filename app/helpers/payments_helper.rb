module PaymentsHelper
  def state_class(state)
    if state == 'Conciliado'
      content_tag(:span, 'C', class: 'label label-success')
    else
      content_tag(:span, 'A', class: 'label label-info')
    end
  end

  def add_withholding_fields_for(f)
    new_object = f.object.send(:withholdings).klass.new
    id = new_object.object_id
    fields = f.fields_for('withholdings', new_object, child_index: id) do |builder|
      render('withholding_fields', f: builder)
    end

    link_to('#', class: 'add_fields btn btn-primary', data: { id: id, fields: fields.delete("\n", '') }) do
      content_tag(:i, nil, class: 'fa fa-plus fa-fw')
    end
  end

  def calculate_gross_amount(payment)
    payment.base_value + payment.vat_value
  end

  def normalize_values(value)
    if value > 1
      hundreds = value.to_i.digits.reverse[-3..-1]
      hundreds = hundreds ? hundreds.join.to_i : 0
      hundreds = value > 0 ? value.to_i.digits.reverse[-3..-1].join.to_i : 0
      value = value.to_i - hundreds
      if hundreds > 250
        if hundreds < 750
          value = value + 500
        else
          value = value + 1000
        end
      else
        value = value - 1000 if hundreds > 0
      end
    end
    value
  end

  def taxes(payment)
    taxes = {}
    # used_taxes = []
    # payment.withholdings.each do |wth|
    #   used_taxes.push(wth.tax_id)
    # end
    Tax.where(['initial_date < :date AND end_date > :date', {date: payment.date}]).each  do |tax|
      if tax.city_id
        taxes["#{tax.id}"] = "#{tax.abbreviation} - #{tax.city.name} - #{tax.percentage}%"
      else
        taxes["#{tax.id}"] = "#{tax.abbreviation} - #{tax.percentage}%"
      end
    end
    taxes
  end

  def payment_form_props
    {
      vat: @payment.vat,
      percentage: @payment.vat_percentage.to_json,
      prepayment: @payment.prepayment.to_json
    }
  end
end

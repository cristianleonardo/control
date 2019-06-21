# coding: utf-8
module UsersHelper
  def user_group_name_in_spanish(role_group)
    case role_group
    when 'administration' then 'Administración'
    when 'financial' then 'Financiero'
    when 'financial_assistant' then 'Asistente Financiero'
    when 'recruitment' then 'Contratación'
    when 'supervision' then 'Supervisión'
    when 'reports' then 'Consulta'
    end
  end
end

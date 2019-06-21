# coding: utf-8
Rails.application.routes.draw do

  ###
  # devise gem
  ###
  devise_for :users, skip: [:password], path: "sesion", path_names: { sign_in: 'ingresar', sign_out: 'salir' }
  as :user do
    post  '/autenticacion/contrasena' => 'devise/passwords#create', as: :user_password
    get   '/autenticacion/contrasena/nueva' => 'devise/passwords#new', as: :new_user_password
    get   '/autenticacion/contrasena/editar' => 'devise/passwords#edit', as: :edit_user_password
    patch '/autenticacion/contrasena' => 'devise/passwords#update'
    put   '/autenticacion/contrasena' => 'devise/passwords#update'
  end

  ###
  # Administration scope
  ###
  namespace :api do
    resources :transactions, only: [:create, :destroy]
    get "sessions/email_is_registrated", to: "sessions#email_is_registrated"
    get 'medias/:id', to: 'medias#show'
    delete 'medias/:id', to: 'medias#destroy'


    get 'sub_components/:component_id', to: 'sub_components#fetch_subcomponents'

    get 'committee_minutes/:annual_budget_id', to: 'committee_minutes#fetch_minutes'
    get 'avaiability_letters/:committee_minute_id', to: 'avaiability_letters#fetch_letters'
    get 'inputs/:provider_id', to: 'inputs#fetch_inputs'
    get 'contracts/:id', to: 'contracts#show'
    get 'committee_minutes/:id', to: 'committee_minutes#show'
    get 'avaiability_letters/:id', to: 'avaiability_letters#show'
    get 'contracts/:id/medias', to: 'contracts#medias'
    get 'committee_minutes/:id/medias', to: 'committee_minutes#medias'
    get 'avaiability_letters/:id/medias', to: 'avaiability_letters#medias'
    post 'medias/:type/:id', to: 'medias#create'
  end

  scope :a do
    resources :users, :path => 'usuarios', :path_names => { new: 'nuevo', edit: 'editar' }, except: [:show, :destroy] do
      member do
        post 'reinvitar', to: 'users#send_invitation', as: :send_invitation
        post '/habilitar', to: 'users#enable', as: :enable
        post '/deshabilitar', to: 'users#disable', as: :disable
      end
    end

    resources :invitations, :path => 'invitaciones', module: 'users', :path_names => { edit: 'editar' }, only: [:edit, :update]

    get 'tablero', to: 'dashboard#index', as: :dashboard
    get 'tablero/sources_chart', to: 'dashboard#sources_chart', as: :charts
    get 'tablero/rp_sources_chart', to: 'dashboard#rp_sources_chart', as: :rpcharts
    resources :contract_types, :path => 'tipos_de_contrato', :path_names => { new: 'nuevo', edit: 'editar' }, except: [:show]

    resources :sources, :path => 'fuentes', :path_names => { new: 'nueva', edit: 'editar' } do
      resources :incomes, :path => 'ingresos', :path_names => { new: 'nuevo', edit: 'editar' }, except: [:show], module: :sources
    end

    resources :reports, only: :index, :path => 'reportes' do
      get 'impuestos', to: 'reports#withholdings', on: :collection, as: :withholdings
      get 'financiero', to: 'reports#financial', on: :collection, as: :financial
      get 'pda', to: 'reports#pda', on: :collection, as: :pda
      get 'cdr_sin_contrato', to: 'reports#cdr_without_contract', on: :collection, as: :cdr_without_contract
      get 'saldo_disponible_contrato', to: 'reports#available_balance_contract', on: :collection, as: :available_balance_contract
      get 'subcomponente_y_fuente', to: 'reports#subcomponent_and_source', on: :collection, as: :subcomponent_and_source
      get 'diseño_reporte_mod', to: 'reports#design_mod', on: :collection, as: :design_mod
      get 'fia', to: 'reports#fia', on: :collection, as: :fia
      get 'impuestos_por_municipio', to: 'reports#taxes_by_municipio', on: :collection, as: :taxes_by_municipio
    end

    resources :strategic_planning, :path => 'planeacion_estrategica', only: [:index,:show]

    resources :contractor_types, :path => 'tipos_de_contratistas', :path_names => { new: 'nuevo', edit: 'editar' }, except: [:show]
    resources :work_types, :path => 'tipos_de_obra', :path_names => { new: 'nuevo', edit: 'editar' }, except: [:show]
    resources :components, :path => 'componentes', :path_names => { new: 'nuevo', edit: 'editar' }, except: [:show] do
      resources :sub_components, :path => 'sub_componentes', :path_names => { new: 'nuevo', edit: 'editar'}, except: [:show]
    end

    resources :general_parameters, :path => 'parametros_generales', :path_names => { new: 'nuevo', edit: 'editar' }
    resources :contractors, :path => 'contratistas', :path_names => { new: 'nuevo', edit: 'editar' }
    resources :providers, :path => 'proveedores', :path_names => { new: 'nuevo', edit: 'editar' }
    resources :inputs, :path => 'insumos', :path_names => { new: 'nuevo', edit: 'editar' }
    resources :works, :path => 'obras', :path_names => { new: 'nuevo', edit: 'editar' } do
      resources :inventories, :path => 'inventario', :path_names => {new: 'nuevo', edit: 'editar'}, except: [:show] do
        resources :purchase_orders, :path => 'orden_de_compra', :path_names => {new: 'nuevo', edit: 'editar'}, except: [:show]
      end
      get 'invenroy/inputs', to: 'inventories#inputs'
    end

    resources :certificates, :path => 'certificados', :path_names => { new: 'nuevo', edit: 'editar' } do
      resources :designates, :path => 'fuentes', :path_names => {new: 'nuevo', edit: 'editar'}, except: [:show]
      get 'reporte', to: 'certificates#report', on: :collection, as: :report
    end
    get 'certificates/search', to: 'certificates#search'
    get 'certificates/clean', to: 'certificates#clean'

    resources :contracts, :path => 'contratos', :path_names => { new: 'nuevo', edit: 'editar' } do
      # get 'contracts/:id/medias', to: 'contracts#medias'
      resources :additions, :path => 'adiciones', :path_names => { new: 'nuevo', edit: 'editar' }, except: [:show]
      resources :budgets, :path => 'presupuestos', :path_names => { new: 'nuevo', edit: 'editar' }, except: [:show]
      get 'reporte', to: 'contracts#report', on: :collection, as: :report
    end
    get 'contracts/search', to: 'contracts#search'
    get 'contracts/clean', to: 'contracts#clean'

    resources :taxes, :path => 'impuestos', :path_names => { new: 'nuevo', edit: 'editar' }, except: [:show]

    resources :payments, :path => 'pagos', :path_names => {new:'nuevo', edit: 'editar'}, except: [:show] do
      member do
        get 'fondos', to: 'payments#expenditures', as: :expenditures
        get 'retenciones', to: 'payments#withholdings', as: :withholdings
        get 'conciliacion', to: 'payments#concile_payment', as: :conciliation
        patch 'conciliar', to: 'payments#update_payment_conciliation', as: :conciliate
      end
    end
    get 'payments/search', to: 'payments#search'
    get 'payments/clean', to: 'payments#clean'
  end
  resources :annual_budgets, :path => 'presupuestos_anuales', :path_names => {new:'nuevo', edit: 'editar'}, except: [:show] do
    resources :committee_minutes, :path => 'actas_de_comite', :path_names => {new:'nuevo', edit: 'editar'}, except: [:show] do
      resources :avaiability_letters, :path => 'cartas_de_viabilidad', :path_names => {new: 'nuevo', edit: 'editar'}, except: [:show]
    end
    resources :source_annual_budgets, :path => 'presupuestos_anuales', :path_names => {new:'nuevo', edit: 'editar'}, except: [:show]
  end

  ###
  # pretender gem
  ###
  resources :users, only: [:index] do
    post :impersonate, on: :member
    post :stop_impersonating, on: :collection
  end

  root 'works#index'
end

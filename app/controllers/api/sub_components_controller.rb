module API
  class SubComponentsController < ApplicationController
    before_action :authenticate_user!
    def fetch_subcomponents
      render json: SubComponent.where(component_id: params[:component_id]).to_json
    end
  end
end

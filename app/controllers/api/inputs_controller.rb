module API
  class InputsController < ApplicationController
    before_action :authenticate_user!

    def fetch_inputs
      provider = Provider.find(params[:provider_id])
      render json: provider.inputs.select(:id, :name).to_json
    end

  end
end

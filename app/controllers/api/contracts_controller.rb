module API
  class ContractsController < ApplicationController
    before_action :authenticate_user!

    def show
      render json: Contract.find(params[:id]).to_json
    end

    def medias
      contract = Contract.find(params[:id])
      render json: contract.medias
            .order('id DESC')
            .to_json
    end
  end
end

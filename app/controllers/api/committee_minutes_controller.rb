module API
  class CommitteeMinutesController < ApplicationController
    before_action :authenticate_user!

    def show
      render json: CommitteeMinute.find(params[:id]).to_json
    end

    def medias
      minute = CommitteeMinute.find(params[:id])
      render json: minute.medias
            .order('id DESC')
            .to_json
    end

    def fetch_minutes
      render json: CommitteeMinute.where(annual_budget_id: params[:annual_budget_id]).to_json
    end
  end
end

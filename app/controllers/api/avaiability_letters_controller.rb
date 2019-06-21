module API
  class AvaiabilityLettersController < ApplicationController
    before_action :authenticate_user!

    def show
      render json: AvaiabilityLetter.find(params[:id]).to_json
    end

    def medias
      letter = AvaiabilityLetter.find(params[:id])
      render json: letter.medias
            .order('id DESC')
            .to_json
    end

    def fetch_letters
      render json: AvaiabilityLetter.where(committee_minute_id: params[:committee_minute_id]).to_json
    end

  end
end

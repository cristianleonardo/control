module API
  class MediasController < ApplicationController
    before_action :authenticate_user!

    def show
      render json: Media.find(params[:id]).to_json
    end

    def create
      if params[:type] == 'contract'
        @media = Media.new(
          file: params[:file],
          name: params[:file].original_filename,
          contract_id: params[:id]
        )
      elsif params[:type] == 'committee_minute'
        @media = Media.new(
          file: params[:file],
          name: params[:file].original_filename,
          committee_minute_id: params[:id]
        )
      else
        @media = Media.new(
          file: params[:file],
          name: params[:file].original_filename,
          avaiability_letter_id: params[:id]
        ) 
      end
      if @media.save!
        respond_to do |format|
          format.json{ render :json => @media }
        end
      end
    end

    def destroy
      media = Media.find(params[:id])
      media.destroy
    end
  end
end

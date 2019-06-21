# encoding: utf-8
class MediaUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    if model.contract
      "uploads/#{model.class.to_s.underscore}/#{model.contract.id}/#{model.id}"
    elsif model.committee_minute
      "uploads/#{model.class.to_s.underscore}/#{model.committee_minute.id}/#{model.id}"
    else
      "uploads/#{model.class.to_s.underscore}/#{model.avaiability_letter.id}/#{model.id}"
    end
  end
end

class Media < ApplicationRecord
  mount_uploader :file, MediaUploader
  belongs_to :contract
end

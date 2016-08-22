class AttachFile < ActiveRecord::Base
  belongs_to :fileable, :polymorphic => true
  mount_uploader :path, AttachFileUploader

  validates :path, :presence => true
end
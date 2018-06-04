class PersonalIdentification < ApplicationRecord
  acts_as_paranoid
  mount_uploaders :files, FileUploader
  serialize :files

  belongs_to :user
end

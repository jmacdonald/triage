class Attachment < ActiveRecord::Base
  belongs_to :request
  belongs_to :user

  validates :title, :request, :user, :presence => true
  has_attached_file :file

  validates_attachment :file, :presence => true, :size => { :in => 0..5.megabytes }

  def file_name
    self.file_file_name
  end
end

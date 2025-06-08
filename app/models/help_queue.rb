class HelpQueue < ApplicationRecord
  belongs_to :course_session
  has_many :help_requests, dependent: :destroy
end

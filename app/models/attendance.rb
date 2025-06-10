class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :course_session

  validates :timestamp, presence: true
end

class CourseSession < ApplicationRecord
  belongs_to :course
  validates :date, presence: true, uniqueness: { scope: :course_id }
  has_one :help_queue, dependent: :destroy
end

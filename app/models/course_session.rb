class CourseSession < ApplicationRecord
  belongs_to :course
  validates :date, presence: true, uniqueness: { scope: :course_id }
  has_one :help_queue, dependent: :destroy
  has_many :attendances, dependent: :destroy

  def attendance_closed?
    attendance_checkin_ended_at.present?
  end

end

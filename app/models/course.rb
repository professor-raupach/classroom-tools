class Course < ApplicationRecord
  belongs_to :instructor, class_name: "User"
  # app/models/course.rb
  belongs_to :tutor, class_name: "User", optional: true
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments, source: :user
  has_many :course_sessions, dependent: :destroy

  default_scope {
    left_joins(:instructor).order(
      Arel.sql("LOWER(course_number) ASC"),
      Arel.sql("LOWER(users.last_name) ASC"),
      Arel.sql("LOWER(users.first_name) ASC")
    )
  }

  scope :active, -> {
    where("start_date <= ? AND end_date >= ?", Date.current, Date.current)
  }

  scope :live, -> {
    now = Time.now
    today = now.to_date
    current_time = now.strftime("%H:%M:%S")  # matches SQL TIME format
    weekday = now.strftime("%A").downcase

    where("#{weekday} = ?", true)
      .where("start_date <= ? AND end_date >= ?", today, today)
      .where("start_time <= ? AND end_time >= ?", current_time, current_time)
  }

  def active?
    today = Date.current
    start_date <= today && end_date >= today
  end

  def live?
    now = Time.now
    today = now.to_date
    current_time = now.strftime("%H:%M")
    weekday = now.strftime("%A").downcase # e.g., "monday"

    start_date <= today &&
      end_date >= today &&
      start_time.strftime("%H:%M") <= current_time &&
      end_time.strftime("%H:%M") >= current_time &&
      send("#{weekday}?")
  end

  def instructor_or_tutor?(user)
    instructor == user || tutor == user
  end

end

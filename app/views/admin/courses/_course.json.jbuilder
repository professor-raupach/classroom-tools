json.extract! course, :id, :course_number, :title, :instructor_id, :year, :semester, :start_date, :end_date, :start_time, :end_time, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, :created_at, :updated_at
json.url course_url(course, format: :json)

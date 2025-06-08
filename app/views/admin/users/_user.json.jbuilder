json.extract! user, :id, :first_name, :last_name, :student_id, :email, :student, :instructor, :admin, :created_at, :updated_at
json.url user_url(user, format: :json)

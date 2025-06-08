class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :enrollments, dependent: :destroy
  has_many :enrolled_courses, through: :enrollments, source: :course
  has_many :instructed_courses, class_name: "Course", foreign_key: "instructor_id", dependent: :nullify
  has_many :help_requests

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
  def student?
    student
  end

  def instructor?
    instructor
  end

  def admin?
    admin
  end
end

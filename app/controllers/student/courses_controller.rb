module Student
  class CoursesController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_student

    def index
      @enrolled_courses = current_user.enrolled_courses
      @available_courses = Course.active.where.not(id: @enrolled_courses.pluck(:id))
    end

    def enroll
      course = Course.find(params[:id])
      if course.active? && !current_user.enrolled_courses.include?(course)
        current_user.enrolled_courses << course
        flash[:notice] = "You have been enrolled in #{course.course_number}."
      else
        flash[:alert] = "Unable to enroll in that course."
      end
      redirect_to student_courses_path
    end

    def unenroll
      course = Course.find(params[:id])
      if current_user.enrolled_courses.include?(course)
        current_user.enrolled_courses.destroy(course)
        flash[:notice] = "You have been unenrolled from #{course.course_number}."
      else
        flash[:alert] = "You are not enrolled in that course."
      end
      redirect_to student_courses_path
    end

    private

    def ensure_student
      redirect_to root_path, alert: "Access denied." unless current_user.student?
    end
  end
end

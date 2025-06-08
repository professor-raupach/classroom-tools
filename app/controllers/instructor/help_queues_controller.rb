module Instructor
  class HelpQueuesController < ApplicationController
    before_action :authenticate_user!
    before_action :require_instructor!

    def index
      @live_courses = current_user.instructed_courses.live
      @help_queues = current_user.instructed_courses
                                 .includes(course_sessions: :help_queue)
                                 .flat_map(&:course_sessions)
                                 .map(&:help_queue)
                                 .compact
    end

    def new
      live_course = current_user.instructed_courses.find(&:live?)
      unless live_course
        redirect_to instructor_courses_path, alert: "No live course found."
        return
      end

      @course_session = live_course.course_sessions.find_or_create_by(date: Date.today)
      if @course_session.help_queue
        redirect_to instructor_help_queue_path(@course_session.help_queue)
      else
        @help_queue = @course_session.build_help_queue
      end
    end

    def create
      course = current_user.instructed_courses.find_by(id: params[:course_id])
      unless course
        redirect_to instructor_help_queues_path, alert: "Course not found or not authorized."
        return
      end

      course_session = course.course_sessions.find_or_create_by(date: Date.today)

      help_queue = course_session.help_queue || course_session.create_help_queue

      redirect_to instructor_help_queue_path(help_queue)
    end

    def show
      @help_queue = HelpQueue.includes(:help_requests).find(params[:id])
      @qr_code_url = generate_qr_code_url(@help_queue)
      @help_requests = @help_queue.help_requests.includes(:user).order(:created_at)

      respond_to do |format|
        format.html # renders show.html.erb
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "help_queue_list",
            partial: "instructor/help_queues/list",
            locals: { help_queue: @help_queue, help_requests: @help_requests }
          )
        end
      end

    end

    # app/controllers/instructor/help_queues_controller.rb
    def list
      @help_queue = HelpQueue.find(params[:id])
      @help_requests = @help_queue.help_requests.order(:created_at)

      render partial: "instructor/help_queues/list", locals: { help_queue: @help_queue, help_requests: @help_requests }
    end

    def manage
      @help_queue = HelpQueue.find(params[:id])
      @help_requests = @help_queue.help_requests.order(:created_at)
    end

    private

    def help_queue_params
      params.require(:help_queue).permit(:status)
    end

    def require_instructor!
      redirect_to root_path unless current_user.instructor?
    end

    def generate_qr_code_url(help_queue)
      enroll_url = new_student_help_request_url(help_queue_id: help_queue.id)
      "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=#{CGI.escape(enroll_url)}"
    end
  end
end

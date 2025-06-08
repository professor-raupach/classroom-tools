module Student
  class HelpRequestsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_student!

    def new
      @help_queue = HelpQueue.find_by(id: params[:help_queue_id])
      return redirect_to root_path, alert: "Help Queue not found." unless @help_queue

      if @help_queue.course_session.course.instructor_or_tutor?(current_user)
        redirect_to manage_instructor_help_queue_path(@help_queue)
      else
        @help_request = @help_queue.help_requests.find_by(user_id: current_user.id)
        if @help_request
          redirect_to student_help_request_path(@help_request), alert: "You’re already in the queue."
        else
          @help_request = HelpRequest.new
        end
      end
    end


    def create
      @help_queue = HelpQueue.find(params[:help_request][:help_queue_id])
      @help_request = @help_queue.help_requests.find_by(user_id: current_user.id)
      if @help_request
        redirect_to student_help_request_path(@help_request), alert: "You’re already in the queue."
      else
        @help_request = @help_queue.help_requests.create(user: current_user)
        redirect_to student_help_request_path(@help_request), notice: "You’ve been added to the help queue."
      end
    end

    def show
      @help_request = HelpRequest.find(params[:id])
      @help_queue = @help_request.help_queue
      @position = @help_queue.help_requests.order(:created_at).pluck(:id).index(@help_request.id) + 1
    end

    def destroy
      @help_request = current_user.help_requests.find_by(id: params[:id])
      if @help_request
        @help_queue = @help_request.help_queue
        @help_request.destroy
        redirect_to removed_student_help_requests_path(help_queue_id: @help_queue.id), notice: "You have been removed from the help queue."
      else
        @help_queue = HelpQueue.find(params[:help_queue_id])
        redirect_to removed_student_help_requests_path(help_queue_id: @help_queue.id), alert: "You were already removed from the help queue."
      end
    end

    def removed
      @help_queue = HelpQueue.find(params[:help_queue_id])
      @course = @help_queue.course_session.course
    end

    private

    def require_student!
      redirect_to root_path unless current_user.student?
    end
  end
end

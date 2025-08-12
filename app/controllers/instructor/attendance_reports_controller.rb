module Instructor
  class AttendanceReportsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_course
    before_action :authorize_instructor_for_course!

    include AttendanceReportCommon

    private
    def set_course
      @course = Course.find(params[:id])
    end

    def authorize_instructor_for_course!
      allowed =
        if @course.respond_to?(:instructor_id)
          @course.instructor_id == current_user.id
        else
          current_user.respond_to?(:instructor?) && current_user.instructor?
        end
      head :forbidden unless allowed || (current_user.respond_to?(:admin?) && current_user.admin?)
    end
  end
end

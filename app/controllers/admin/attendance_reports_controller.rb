module Admin
  class AttendanceReportsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_course
    before_action :authorize_admin!

    include AttendanceReportCommon

    private
    def set_course
      @course = Course.find(params[:id])
    end

    def authorize_admin!
      head :forbidden unless current_user&.respond_to?(:admin?) && current_user.admin?
    end
  end
end

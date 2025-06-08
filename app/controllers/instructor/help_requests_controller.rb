class Instructor::HelpRequestsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @help_request = HelpRequest.find(params[:id])
    @help_request.destroy

    redirect_back fallback_location: instructor_help_queues_path,
                  notice: "Removed #{@help_request.user.full_name} from the help queue."
  end
end

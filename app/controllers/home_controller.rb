class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @now = Time.current

    @is_admin      = current_user.respond_to?(:admin?) && current_user.admin?
    @is_instructor = current_user.respond_to?(:instructor?) && current_user.instructor?
    @is_student    = !@is_admin && !@is_instructor # adjust if you have an explicit student role

    if @is_admin
      load_admin_dashboard
    elsif @is_instructor
      load_instructor_dashboard
    else
      load_student_dashboard
    end
  end

  private

  # ----- Admin: see everything, emphasize live courses/sessions -----
  def load_admin_dashboard
    @courses = Course.includes(:course_sessions).order(created_at: :desc).limit(12)

    # If you have Course#current_live_session or CourseSession.live_now scope, use them; else:
    @live_courses = @courses.select { |c| c.respond_to?(:live?) ? c.live? : c.course_sessions.any? }
  end

  # ----- Instructor: only their courses, plus "live now" shortcuts -----
  def load_instructor_dashboard
    # Adjust .instructed_courses to your association
    @courses = current_user.instructed_courses.includes(:course_sessions).order(created_at: :desc)

    @live_courses =
      if @courses.first&.respond_to?(:live?)
        @courses.select(&:live?)
      else
        @courses # fallback, but ideally implement Course#live?
      end

    # Optional: upcoming sessions in next 7 days
    if CourseSession.respond_to?(:where)
      @upcoming_sessions = CourseSession
                             .joins(:course)
                             .where(course_id: @courses.select(:id))
                             .where(date: Time.zone.today..(Time.zone.today + 7.days))
                             .order(:date, :start_time)
                             .limit(20)
    else
      @upcoming_sessions = []
    end
  end

  # ----- Student: enrolled courses & today’s session (if applicable) -----
  def load_student_dashboard
    # Adjust enrollment association to your schema
    @courses = Course.joins(:enrollments)
                     .where(enrollments: { user_id: current_user.id })
                     # .select('courses.*, LOWER(courses.title) AS sort_title')
                     # .distinct
                     # .order('sort_title ASC')

    # If you track a “current session” logic, expose it for quick access:
    @today_sessions = if defined?(CourseSession)
                        CourseSession.joins(:course)
                                     .where(course_id: @courses.select(:id), date: Time.zone.today)
                                     .order(:start_time)
                      else
                        []
                      end
  end
end

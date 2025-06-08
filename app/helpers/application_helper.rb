module ApplicationHelper

  def course_path_for(course)
    if controller_path.start_with?("instructor/")
      [:instructor, course]
    else
      [:admin, course]
    end
  end

end

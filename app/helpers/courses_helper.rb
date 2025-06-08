module CoursesHelper

    def course_form_url(namespace, course)
      if course.persisted?
        polymorphic_path([namespace, course])
      else
        polymorphic_path([namespace, :courses])
      end
    end

end

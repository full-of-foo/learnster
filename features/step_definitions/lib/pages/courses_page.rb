module Pages

  class CoursesPage < Pages::Page

    attr_accessor :title_field
    attr_accessor :section_title_field
    attr_accessor :description_field
    attr_accessor :identifier_field
    attr_accessor :update_title_field
    attr_accessor :update_description_field

    attr_accessor :add_course_button
    attr_accessor :add_module_button
    attr_accessor :add_student_button
    attr_accessor :remove_module_button
    attr_accessor :remove_student_button
    attr_accessor :add_course_section_button
    attr_accessor :update_course_button

    attr_accessor :drop_down_link
    attr_accessor :export_link
    attr_accessor :search_term_field
    attr_accessor :search_button

    attr_accessor :grid_title_cell

    attr_accessor :delete_course_button

    def initialize(browser)
      super(browser)

      @title_field              = @browser.text_field(name: 'title')
      @section_title_field      = @browser.text_field(name: 'section')
      @update_title_field       = @browser.text_field(id: 'title')
      @description_field        = @browser.text_field(name: 'description')
      @update_description_field = @browser.text_field(id: 'description')
      @identifier_field         = @browser.text_field(name: 'identifier')

      @add_course_button        = @browser.button(id: 'Add Course')
      @add_course_section_button = @browser.button(id: 'Add Section')
      @add_module_button        = @browser.button(id: 'Add Module')
      @add_student_button       = @browser.button(id: 'Add Student')
      @remove_module_button     = @browser.span(id: 'remove-module-button')
      @remove_student_button     = @browser.span(id: 'remove-student-button')
      @update_course_button     = @browser.button(id: 'Update')

      @drop_down_link           = @browser.link(class: 'btn dropdown-toggle')
      @export_link              = @browser.link(text: 'Export All')
      @search_term_field        = @browser.text_field(id: 'search')
      @search_button            = @browser.button(text: 'Search')

      @delete_course_button = @browser.button(id: 'delete-course-button')
    end

    # operations

    def submit_new_course_form(course)
      self.title_field.when_present.set(course.title)
      self.description_field.when_present.set(course.description)
      self.identifier_field.set(course.identifier)

      self.add_course_button.click
    end

    def submit_new_course_section_form(course_section)
      self.section_title_field.when_present.set(course_section.title)
      self.add_course_section_button.click
    end

    def submit_edit_course_form(title, description)
      self.update_title_field.when_present.set(title)
      self.update_description_field.set(description)

      self.update_course_button.click
    end

    def submit_add_first_module_form
      sleep(0.2)
      self.add_module_button.when_present.wd.location_once_scrolled_into_view
      self.add_module_button.when_present.click
    end

    def submit_remove_first_module_form
      sleep(0.2)
      self.remove_module_button.when_present.wd.location_once_scrolled_into_view
      self.remove_module_button.when_present.click
    end

    def submit_add_first_student_form
      sleep(0.2)
      self.add_student_button.when_present.wd.location_once_scrolled_into_view
      self.add_student_button.when_present.click
    end

    def submit_remove_first_student_form
      sleep(0.2)
      self.remove_student_button.when_present.wd.location_once_scrolled_into_view
      self.remove_student_button.when_present.click
    end

    def grid_title_cell(title_text)
      self.grid_title_cell = @browser.td(text: title_text)
    end

    def select_grid_course_title(text_field)
      grid_title_cell(text_field).when_present.click
    end

    def export_courses
      self.drop_down_link.when_present.click
      self.export_link.click
    end

    def select_delete_icon_from_grid(title)
      e = grid_title_cell(title)
      e.wd.location_once_scrolled_into_view
      e.when_present.hover
      sleep 0.3

      @browser.execute_script("$('.scroll-hor-wrapper').scrollLeft(200);")
      sleep 0.2
      e.parent.tds.last.div(class: "delete-icon").i.when_present.click
    end

    def delete_course(title)
      select_delete_icon_from_grid(title)
      self.delete_course_button.when_present.click
      sleep 1.2
    end

  end

end

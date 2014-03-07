module Pages

  class DeliverablesPage < Pages::Page

    attr_accessor :title_field
    attr_accessor :description_field
    attr_accessor :date_field

    attr_accessor :notes_field
    attr_accessor :markup_field

    attr_accessor :update_title_field
    attr_accessor :update_description_field
    attr_accessor :update_date_field

    attr_accessor :update_notes_field
    attr_accessor :update_markup_field

    attr_accessor :create_button
    attr_accessor :update_button
    attr_accessor :create_wiki_button
    attr_accessor :update_wiki_button


    def initialize(browser)
      super(browser)
      @title_field                = @browser.text_field(name: 'title')
      @description_field          = @browser.text_field(name: 'description')
      @date_field                 = @browser.text_field(name: 'due_date')

      @notes_field                = @browser.text_field(name: 'notes')
      @markup_field               = @browser.text_field(name: 'wiki_markup')

      @update_title_field         = @browser.text_field(id: 'title')
      @update_description_field   = @browser.text_field(id: 'description')
      @update_date_field          = @browser.text_field(id: 'due_date')

      @update_notes_field         = @browser.text_field(id: 'notes')
      @update_markup_field        = @browser.text_field(id: 'wiki_markup')

      @create_button        = @browser.button(id: 'Create')
      @update_button        = @browser.button(id: 'Update')

      @create_wiki_button       = @browser.button(id: 'Create Wiki')
      @update_wiki_button       = @browser.button(id: 'Update Wiki')
    end

    def submit_new_deliverable_form(deliverable)
      self.title_field.when_present.set(deliverable.title)
      self.description_field.set(deliverable.description)
      @browser.execute_script("$('#due_date').datepicker('setValue', '#{deliverable.due_date}');")

      self.create_button.click
    end

    def submit_edit_deliverable_form(title, description, due_date)
      self.update_title_field.when_present.set(title)
      self.update_description_field.set(description)
      @browser.execute_script("$('#due_date').datepicker('setValue', '#{due_date}');")

      self.update_button.click
    end

    def submit_new_wiki_submission(wiki_submission)
      self.notes_field.when_present.set(wiki_submission.notes)
      @browser.execute_script("tinymce.activeEditor.selection.setContent('<strong>#{wiki_submission.wiki_markup}</strong>');")

      self.create_wiki_button.click
    end

    def submit_update_wiki_submission(notes, markup)
      self.update_notes_field.when_present.set(notes)
      @browser.execute_script("tinymce.activeEditor.selection.setContent('');")
      @browser.execute_script("tinymce.activeEditor.selection.setContent('<strong>#{markup}</strong>');")

      self.update_wiki_button.click
    end

  end

end

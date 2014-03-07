module Pages

  class SupplementPage < Pages::Page

    attr_accessor :title_field
    attr_accessor :description_field
    attr_accessor :wiki_markup_field
    attr_accessor :update_title_field
    attr_accessor :update_description_field
    attr_accessor :update_wiki_markup_filed

    attr_accessor :create_wiki_button
    attr_accessor :update_wiki_button


    def initialize(browser)
      super(browser)
      @title_field                = @browser.text_field(name: 'title')
      @description_field          = @browser.text_field(name: 'description')
      @wiki_markup_filed          = @browser.text_field(name: 'wiki_markup')
      @update_title_field         = @browser.text_field(id: 'title')
      @update_description_field   = @browser.text_field(id: 'description')
      @update_wiki_markup_filed   = @browser.text_field(id: 'wiki_markup')

      @create_wiki_button     = @browser.button(id: 'Create Wiki')
      @update_wiki_button     = @browser.button(id: 'Update Wiki')
    end

    def submit_new_wiki_form(wiki)
      self.title_field.when_present.set(wiki.title)
      self.description_field.set(wiki.description)
      @browser.execute_script("tinymce.activeEditor.selection.setContent('<strong>#{wiki.wiki_markup}</strong>');")

      self.create_wiki_button.click
    end

    def submit_edit_wiki_form(title, description, wiki_markup)
      self.update_title_field.when_present.set(title)
      self.update_description_field.set(description)
      @browser.execute_script("tinymce.activeEditor.selection.setContent('');")
      @browser.execute_script("tinymce.activeEditor.selection.setContent('<strong>#{wiki_markup}</strong>');")

      self.update_wiki_button.click
    end

  end

end

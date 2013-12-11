module Pages

  class OrganisationsPage < Pages::Page

    attr_accessor :add_organisation_link
    attr_accessor :close_well_button
    attr_accessor :title_field
    attr_accessor :update_title_field
    attr_accessor :description_field
    attr_accessor :update_description_field
    attr_accessor :add_organisation_button
    attr_accessor :update_organisation_button

    attr_accessor :drop_down_link
    attr_accessor :export_link
    attr_accessor :search_term_field
    attr_accessor :search_button

    attr_accessor :grid_title_cell

    attr_accessor :delete_organisation_button

    def initialize(browser)
      super(browser)
      @url = url("/#/organisations")

      @add_organisation_link      = @browser.link(id: 'new-org-button')
      @close_well_button          = @browser.button(class: 'close cancel-new-org')
      @title_field                = @browser.text_field(name: 'title')
      @update_title_field         = @browser.text_field(id: 'title')
      @description_field          = @browser.text_field(name: 'description')
      @update_description_field   = @browser.text_field(id: 'description')
      @add_organisation_button    = @browser.button(id: 'Add Organisation')
      @update_organisation_button = @browser.button(id: 'Update')

      @drop_down_link           = @browser.link(class: 'btn dropdown-toggle')
      @export_link              = @browser.link(text: 'Export All')
      @search_term_field        = @browser.text_field(id: 'search')
      @search_button            = @browser.button(text: 'Search')

      @delete_organisation_button = @browser.button(id: 'delete-organisation-button')
    end

    def visit 
      @browser.goto @url
    end

    # operations

    def open_add_well
      @add_organisation_link.when_present.click
    end

    def close_add_well
      @close_well_button.when_present.click
    end

    def submit_new_organisation_form(title, description)
      self.title_field.when_present.set title
      self.description_field.set description
      self.add_organisation_button.click
      sleep 0.2
    end

    def submit_update_organisation_form(title, description)
      self.update_title_field.when_present.set title
      self.update_description_field.set description
      self.update_organisation_button.click
      sleep 0.2
    end

    def search_organisations_grid(search_term)
      self.search_term_field.when_present.set search_term
      self.search_button.click
      sleep 0.2
    end

    def grid_title_cell(title_text)
      self.grid_title_cell = browser.td(text: title_text)
    end

    def select_grid_organainsation_title(text_field)
      grid_title_cell(text_field).when_present.click
    end

    def export_organisations
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

    def delete_organisation(title)
      select_delete_icon_from_grid(title)
      self.delete_organisation_button.when_present.click
      sleep 1.2
    end
    
  end
    
end

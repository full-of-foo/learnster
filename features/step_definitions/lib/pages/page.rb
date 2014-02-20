module Pages

    class Page

      attr_accessor :title

      def initialize(browser)
        @browser = browser
      end

      def method_missing(sym, *args, &block)
        @browser.send sym, *args, &block
      end

      def page_title
        @browser.title
      end

      def resize_window
        @browser.window.resize_to(1300, 960)
      end

      def url(client_url)
        TestConfig.sut << client_url
      end

      def scroll_down
        @browser.div(id: "main-region").wd.location_once_scrolled_into_view
      end

      def submit_search_for(term)
        @browser.text_field(id:'search').when_present.set(term)
        @browser.button(text:'Search').click

        sleep(0.4)
      end

    end

end

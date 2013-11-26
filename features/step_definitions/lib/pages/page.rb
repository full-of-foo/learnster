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
      
    end

end
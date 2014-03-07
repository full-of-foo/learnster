module CacheEntities
    class User
      attr_accessor :first_name, :surname, :email, :password

      def initialize(options = {})
        @first_name  = options[:first_name] || ''
        @surname     = options[:surname] || ''
        @email       = options[:email] || ''
        @password    = options[:password] || ''
      end
    end

    class Organisation
      attr_accessor :title, :description

      def initialize(title, description)
        @title        = title
        @description  = description
      end
    end

    class Course
      attr_accessor :title, :description, :identifier

      def initialize(options = {})
        @title        = options[:title] || ''
        @description  = options[:description] || ''
        @identifier   = options[:identifier] || ''
      end
    end

    class CourseSection
      attr_accessor :title

      def initialize(title)
        @title        = title
      end
    end

    class LearningModule
      attr_accessor :title, :description

      def initialize(options = {})
        @title        = options[:title] || ''
        @description  = options[:description] || ''
      end
    end

    class Supplement
      attr_accessor :title, :description

      def initialize(options = {})
        @title        = options[:title] || ''
        @description  = options[:description] || ''
      end
    end

    class Student < User

      def initialize(options = {})
        super(options)
      end
    end

    class Admin < Student

      def initialize(options = {})
       super(options)
      end
    end

    class WikiContent
      attr_accessor :title, :description, :wiki_markup

      def initialize(options = {})
        @title        = options[:title] || ''
        @description  = options[:description] || ''
        @wiki_markup  = options[:wiki_markup] || ''
      end
    end

    class WikiSubmission
      attr_accessor :notes, :wiki_markup

      def initialize(options = {})
        @notes        = options[:notes] || ''
        @wiki_markup  = options[:wiki_markup] || ''
      end
    end

    class Deliverable
      attr_accessor :title, :description, :due_date

      def initialize(options = {})
        @title        = options[:title] || ''
        @description  = options[:description] || ''
        @due_date     = options[:due_date] || ''
      end
    end

end

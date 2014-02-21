module CacheEntities
    class User
      attr_accessor :first_name, :surname, :email, :password

      def initialize(first_name, surname, email, password)
        @first_name  = first_name
        @surname     = surname
        @email       = email
        @password    = password
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

      def initialize(title, description, identifier)
        @title        = title
        @description  = description
        @identifier   = identifier
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

    class Student
      attr_accessor :first_name, :surname, :email, :password

      def initialize(options = {})
        @first_name  = options[:first_name] || ''
        @surname     = options[:surname] || ''
        @email       = options[:email] || ''
        @password    = options[:password] || ''
      end
    end

    class Admin < Student

      def initialize(options = {})
       super(options)
      end
    end

end

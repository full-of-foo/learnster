module CacheEntites
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

end

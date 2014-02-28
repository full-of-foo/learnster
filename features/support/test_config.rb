module TestConfig

  def self.sut
   ENV['SUT'].nil? ? "http://learnster.co.uk" : "#{ENV['SUT']}"
  end

end

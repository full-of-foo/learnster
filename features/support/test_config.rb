module TestConfig

  def self.sut
   ENV['SUT'].nil? ? "109.74.204.118" : "#{ENV['SUT']}"
  end
  
end
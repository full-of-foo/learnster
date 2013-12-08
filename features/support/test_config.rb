module TestConfig

  def self.sut
    "109.74.204.118" || ENV['SUT']
  end
  
end
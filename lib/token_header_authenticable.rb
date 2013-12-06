module TokenHeaderAuthenticable
  
  def self.valid?
    token_value.present?
  end
  
  def token_value
    if header && header =~ /^Token token="(.+)"$/
      $~[1]
    end
  end
 
  def header
    request.headers["Authorization"]
  end
end
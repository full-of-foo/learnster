# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :teaspoon do
  # Implementation files
  watch(%r{app/assets/javascripts/(.+).js}) { |m| "#{m[1]}_spec" }

  # Specs / Helpers
  watch(%r{spec/javascripts/(.*)})
end

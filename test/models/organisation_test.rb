require 'test_helper'

class OrganisationTest < ActiveSupport::TestCase

  before do
    admin_params = {
      :email => "lightweightdevelopment@gmail.com",
      :first_name => "Foo",
      :password => "foobar",
      :password_confirmation => "foobar",
      :surname => "McSystemadmin"
    }
    org_params = {
      :title              => "Dublin Institute of Technology",
      :description => "A third-level institute based at the heart\
                                  of Dublin city. Passionate about delivering an excellent learning\
                                  experience",
      :created_at => rand(10.years).ago,
      :created_by => OrgAdmin.new(admin_params)
    }

    @organisation ||= Organisation.new(org_params)
  end

  test 'not valid by default' do
    assert_equal false, Organisation.new.valid?
  end

  test 'is valid' do
    assert_equal true, @organisation.valid?
  end

end
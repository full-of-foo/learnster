require 'test_helper'

class OrganisationTest < ActiveSupport::TestCase

  before do
    @organisation ||= create(:organisation)
  end

  test 'not valid by default' do
    assert_equal false, Organisation.new.valid?
  end

  test 'is valid' do
    unsaved_organisation = build(:organisation, title: "foo")

    assert_equal true, unsaved_organisation.valid?
    assert_equal true, @organisation.valid?
  end

end
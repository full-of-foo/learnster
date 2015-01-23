require 'test_helper'

class OrganisationTest < ActiveSupport::TestCase

  test 'not valid by default' do
    assert_equal false, Organisation.new.valid?
  end

  test 'is valid' do
    unsaved_organisation = build(:organisation, title: "foo")
    organisation = create(:organisation)

    assert_equal true, unsaved_organisation.valid?
    assert_equal true, organisation.valid?
  end

  test 'searches' do
        boi = create(:organisation, title: "Bank of Ireland")
        create(:organisation)

        assert_equal 2, Organisation.search_term("").size
        assert_equal 1, Organisation.search_term("Bank").size
        assert_equal boi.title, Organisation.search_term("Bank of").first.title
  end

  test 'checks owned sections' do
        section = create(:course_section)
        organisation = section.course.organisation

        assert_equal true, organisation.has_section?(section.id)
        assert_equal false, organisation.has_section?(666)
  end

end
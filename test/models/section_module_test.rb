require 'test_helper'

class SectionModuleTest < ActiveSupport::TestCase

  test 'not valid by default' do
    assert_equal false, SectionModule.new.valid?
  end

  test 'is valid' do
    unsaved_section_module = build(:section_module)
    section_module = create(:section_module)

    assert_equal true, unsaved_section_module.valid?
    assert_equal true, section_module.valid?
  end

  test 'lists the section modules by org' do
    section = create(:course_section)
    dit_id = section.course.organisation.id
    create(:section_module, course_section: section)
    dcu_id = create(:organisation, :dcu).id

    assert_equal 1, SectionModule.organisation_section_modules(dit_id).size
    assert_equal 0, SectionModule.organisation_section_modules(dcu_id).size
  end

end
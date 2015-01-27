require 'test_helper'

class OrgAdminTest < ActiveSupport::TestCase

  # TODO - test import
  # TODO - test search
  # TODO - test email

  test 'not valid by default' do
    assert_equal false, OrgAdmin.new.valid?
  end

  test 'is valid' do
    unsaved_org_admin = build(:org_admin)
    org_admin = create(:org_admin)

    assert_equal true, unsaved_org_admin.valid?
    assert_equal true, org_admin.valid?
  end

  test 'knows parent model name' do
    assert_equal "User", OrgAdmin.model_name.name
  end

  test 'lists student admins' do
    dit_course_section = create(:course_section)
    dit_student = create(:student)
    create(:enrollment, course_section: dit_course_section, student: dit_student)
    dcu_student = create(:student, :dcu)

    assert_equal 2, OrgAdmin.student_admins(dit_student.id).size
    assert_equal 0, OrgAdmin.student_admins(dcu_student.id).size
  end

  test 'knows model type' do
    org_admin = build(:org_admin)

    assert_equal false, org_admin.student?
    assert_equal true, org_admin.org_admin?
    assert_equal false, org_admin.app_admin?
  end

  test 'knows created students' do
    dit_org_admin = create(:org_admin)
    create(:student, created_by: dit_org_admin)
    dcu_org_admin = create(:org_admin, :dcu)

    assert_equal 1, dit_org_admin.created_students.size
    assert_equal 0, dcu_org_admin.created_students.size
  end

  test 'knows created admins' do
    dit_org_admin = create(:org_admin)
    create(:org_admin, created_by: dit_org_admin)
    dcu_org_admin = create(:org_admin, :dcu)

    assert_equal 1, dit_org_admin.created_admins.size
    assert_equal 0, dcu_org_admin.created_admins.size
  end

  test 'knows organisation ID' do
    dit = create(:organisation)
    dit_org_admin = create(:org_admin, admin_for: dit)

    assert_equal dit.id, dit_org_admin.org_id
  end

  test 'knows organisation title' do
    dit = create(:organisation)
    dit_org_admin = create(:org_admin, admin_for: dit)

    assert_equal dit.title, dit_org_admin.org_title
  end

end

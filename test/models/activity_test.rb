require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  ENTITY_FACTORIES = %w(module deliverable course course_section submission
                        wiki_submission wiki_content content_upload
                        supplement_content submission_upload section_module
                        enrollment)

  test 'is valid by default' do
    assert_equal true, Activity.new.valid?
  end

  test 'is valid with admin and all ENTITY FACTORIES' do
    ENTITY_FACTORIES.each do |factory|
      unsaved_activity = build(:activity, "dit_#{factory}".to_sym, user: build(:org_admin))
      activity = create(:activity, "dit_#{factory}".to_sym, user: create(:org_admin))

      assert_equal true, unsaved_activity.valid?
      assert_equal true, activity.valid?
    end
  end

  test 'is valid with student and all ENTITY FACTORIES' do
    ENTITY_FACTORIES.each do |factory|
      unsaved_activity = build(:activity, "dit_#{factory}".to_sym, user: build(:student))
      activity = create(:activity, "dit_#{factory}".to_sym, user: create(:student))

      assert_equal true, unsaved_activity.valid?
      assert_equal true, activity.valid?
    end
  end

  test 'lists organisation activities' do
    dit = create(:organisation)
    dit_admin = create(:org_admin, admin_for: dit)
    dit_course = create(:course, organisation: dit)
    dit_course_activity = create(:activity, trackable: dit_course, user: dit_admin)
    dcu = create(:organisation, :dcu)

    assert_equal 1, Activity.organisation_activities(dit.id).size
    assert_equal 0, Activity.organisation_activities(dcu.id).size
  end

  test 'lists manager activities' do
    dit = create(:organisation)
    dit_admin = create(:org_admin, admin_for: dit)
    dit_course = create(:course, organisation: dit)
    dit_course_activity = create(:activity, trackable: dit_course, user: dit_admin)

    wiki_submission = create(:wiki_submission)
    dit_student = wiki_submission.student
    dit_course_activity = create(:activity, trackable: wiki_submission, user: dit_student)

    assert_equal 1, Activity.manager_activities(dit_admin.id).size
    assert_equal 0, Activity.manager_activities(dit_student.id).size
  end

  test 'lists student activities' do
    dit = create(:organisation)
    dit_admin = create(:org_admin, admin_for: dit)
    dit_course = create(:course, organisation: dit)
    dit_course_activity = create(:activity, trackable: dit_course, user: dit_admin)

    wiki_submission = create(:wiki_submission)
    dit_student = wiki_submission.student
    dit_course_activity = create(:activity, trackable: wiki_submission, user: dit_student)

    assert_equal 1, Activity.student_activities(dit_admin.id).size
    assert_equal 1, Activity.student_activities(dit_student.id).size
  end

  test 'adds a custom message before create for admin\'s actions on users' do
    admin = create(:org_admin, first_name: "Joey", surname: "Admin")
    student = create(:student, first_name: "Fintan", surname: "The Kid")

    activity = create(:activity, user: admin, trackable: student, action: "create")
    assert_equal activity.message, "created the account of the user Fintan The Kid"

    activity = create(:activity, user: admin, trackable: student, action: "update")
    assert_equal activity.message, "updated the profile of the user Fintan The Kid"
  end

  test 'adds a custom message before create for user\'s actions on wikis' do
    admin = create(:org_admin)
    wiki_submission = create(:wiki_submission)
    wiki_content = create(:wiki_content)

    activity = create(:activity, user: admin, trackable: wiki_submission, action: "create")
    assert_equal activity.message, "created a wiki"
    activity = create(:activity, user: admin, trackable: wiki_content, action: "create")
    assert_equal activity.message, "created a wiki"

    activity = create(:activity, user: admin, trackable: wiki_submission, action: "update")
    assert_equal activity.message, "updated a wiki"
    activity = create(:activity, user: admin, trackable: wiki_content, action: "update")
    assert_equal activity.message, "updated a wiki"
  end

  test 'adds a custom message before create for user\'s actions on uploads' do
    admin = create(:org_admin)
    submission_upload = create(:submission_upload)
    content_upload = create(:content_upload)

    activity = create(:activity, user: admin, trackable: submission_upload, action: "create")
    assert_equal activity.message, "uploaded a submission"
    activity = create(:activity, user: admin, trackable: content_upload, action: "create")
    assert_equal activity.message, "uploaded some module content"

    activity = create(:activity, user: admin, trackable: submission_upload, action: "update")
    assert_equal activity.message, "updated a submission"
    activity = create(:activity, user: admin, trackable: content_upload, action: "update")
    assert_equal activity.message, "updated some module content"
  end

  test 'adds a custom message before create for user\'s actions on courses' do
    admin = create(:org_admin)
    course = create(:course, title: "MSc in Trolz")
    course_section = create(:course_section, section: "1st Year")

    activity = create(:activity, user: admin, trackable: course, action: "create")
    assert_equal activity.message, "created the course MSc in Trolz"
    activity = create(:activity, user: admin, trackable: course_section, action: "create")
    assert_equal activity.message, "created a course section 1st Year"

    activity = create(:activity, user: admin, trackable: course, action: "update")
    assert_equal activity.message, "updated the course MSc in Trolz"
    activity = create(:activity, user: admin, trackable: course_section, action: "update")
    assert_equal activity.message, "updated a course section 1st Year"
  end

  test 'adds a custom message before create for user\'s actions on modules' do
    admin = create(:org_admin)
    learning_module = create(:module, title: "Troll Skills 101")
    module_supplement = create(:module_supplement, title: "Lesson 1")

    activity = create(:activity, user: admin, trackable: learning_module, action: "create")
    assert_equal activity.message, "created the module Troll Skills 101"
    activity = create(:activity, user: admin, trackable: module_supplement, action: "create")
    assert_equal activity.message, "created a module supplement named Lesson 1"

    activity = create(:activity, user: admin, trackable: learning_module, action: "update")
    assert_equal activity.message, "updated the module Troll Skills 101"
    activity = create(:activity, user: admin, trackable: module_supplement, action: "update")
    assert_equal activity.message, "updated a module supplement named Lesson 1"
  end

  test 'adds a custom message before create for user\'s actions on deliverables' do
    admin = create(:org_admin)
    deliverable = create(:deliverable, title: "Big Old Test")

    activity = create(:activity, user: admin, trackable: deliverable, action: "create")
    assert_equal activity.message, "created the deliverable named Big Old Test"
    activity = create(:activity, user: admin, trackable: deliverable, action: "update")
    assert_equal activity.message, "updated the deliverable named Big Old Test"
  end

end

require 'test_helper'

class ModuleSupplementTest < ActiveSupport::TestCase

  test 'not valid by default' do
    assert_equal false, ModuleSupplement.new.valid?
  end

  test 'is valid' do
    unsaved_module_supplement = build(:module_supplement)
    module_supplement = create(:module_supplement)

    assert_equal true, unsaved_module_supplement.valid?
    assert_equal true, module_supplement.valid?
  end

end
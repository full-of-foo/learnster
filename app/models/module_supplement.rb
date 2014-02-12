class ModuleSupplement < ActiveRecord::Base
  belongs_to :learning_module

  has_many :supplement_contents


end

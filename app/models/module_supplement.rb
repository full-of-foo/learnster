class ModuleSupplement < ActiveRecord::Base
  belongs_to :learning_module

  has_many :supplement_contents

  validates_presence_of :title, :learning_module


end

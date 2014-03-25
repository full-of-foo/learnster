class ModuleSupplement < ActiveRecord::Base
  before_destroy :untrack_self

  belongs_to :learning_module
  has_many :supplement_contents, :dependent => :destroy
  has_many :deliverables, :dependent => :destroy

  validates_presence_of :title, :learning_module

  private

    def untrack_self
      Activity.delete_all(trackable_id: self.id) 
    end

end

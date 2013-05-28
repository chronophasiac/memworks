class Coursework < ActiveRecord::Base
  attr_accessible :assignment_id, :completed, :user_id

  validates_presence_of :completed
  validates_presence_of :user
  validates_presence_of :assignment

  belongs_to  :user,
              inverse_of: :courseworks

  belongs_to  :assignment,
              inverse_of: :courseworks
end

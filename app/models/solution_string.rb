class SolutionString < ActiveRecord::Base
  belongs_to  :card,
              inverse_of: :solution_strings

  validates_presence_of :regex, :card

  attr_accessible :card_id, :regex
end
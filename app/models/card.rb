# == Schema Information
#
# Table name: cards
#
#  id           :integer          not null, primary key
#  title        :string(255)      not null
#  instructions :text             not null
#  problem      :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Card < ActiveRecord::Base
  attr_accessible :instructions, :problem, :title

  validates_presence_of :title
  validates_presence_of :instructions
  validates_presence_of :problem
  validates_presence_of :assignments

  has_many  :answers,
            inverse_of: :card,
            dependent: :destroy

  has_many  :card_submissions,
            inverse_of: :card

  has_many  :users,
            through: :card_submissions,
            inverse_of: :cards

  has_many  :card_prerequisites,
            inverse_of: :card,
            dependent: :destroy

  has_many  :assignments,
            through: :card_prerequisites,
            inverse_of: :cards

  has_many  :challenge_decks,
            inverse_of: :card
            
  has_many  :challenges,
            through: :challenge_decks,
            inverse_of: :cards
end

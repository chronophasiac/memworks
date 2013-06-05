# == Schema Information
#
# Table name: card_submissions
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  card_id    :integer
#  helpful    :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CardSubmission < ActiveRecord::Base
  attr_accessible :card_id, :helpful, :user_id

  validates_presence_of :user
  validates_presence_of :card

  belongs_to  :card,
              inverse_of: :card_submissions

  belongs_to  :user,
              inverse_of: :card_submissions

  has_many  :card_submission_logs,
            inverse_of: :card_submission,
            dependent: :destroy
end

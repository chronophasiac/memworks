require 'spec_helper'

describe CardSubmissionLog do
  it { should validate_presence_of(:answer_correct) }
  it { validate_presence_of(:time_taken) }

  it { should belong_to(:card_submission) }
end

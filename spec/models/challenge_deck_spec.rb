require 'spec_helper'

describe ChallengeDeck do
  it { should belong_to(:card) }
  it { should belong_to(:challenge) }
end

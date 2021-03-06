require 'spec_helper'

describe Assignment do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:summary) }
  it { should validate_presence_of(:instructions) }
  it { should validate_presence_of(:assignment_type) }

  it { should allow_value("http://google.com").for(:url) }
  it { should_not allow_value("invalid url").for(:url) }

  it { should allow_value("video").for(:assignment_type) }
  it { should allow_value("text").for(:assignment_type) }
  it { should allow_value("audio").for(:assignment_type) }
  it { should_not allow_value("foo").for(:assignment_type) }

  it { should have_many(:card_prerequisites).dependent(:destroy) }
  it { should have_many(:cards) }

  it { should have_many(:courseworks).dependent(:destroy) }
  it { should have_many(:users) }

  it { should have_many(:assignment_ratings).dependent(:destroy) }
  
  it { should have_many(:activities).dependent(:destroy) }
  it { should have_many(:lessons) }

  context 'with valid attributes' do
    let(:assignment) { FactoryGirl.create(:assignment) }

    it 'is valid' do
      expect(assignment).to be_valid
    end
  end
end

require 'spec_helper'

describe User do
  it { should validate_presence_of(:role) }

  User::ROLES.each do |role|
    it { should allow_value(role).for(:role) }
  end
  it { should_not allow_value("notarole").for(:role) }

  it { should have_many(:card_submissions).dependent(:destroy) }
  it { should have_many(:card_submission_logs) }
  it { should have_many(:cards) }

  it { should have_many(:courseworks).dependent(:destroy) }
  it { should have_many(:assignments) }

  it { should have_many(:assignment_ratings).dependent(:destroy) }

  it { should have_many(:enrollments).dependent(:destroy) }
  it { should have_many(:lessons) }

  it { should have_many(:challenge_completions).dependent(:destroy) }
  it { should have_many(:challenges) }

  it "allows multiple users to be saved" do
    FactoryGirl.create(:user)
    other_user = FactoryGirl.create(:user)
    expect(other_user).to be_valid
  end

  it "validates uniqueness of username" do
    FactoryGirl.create(:user, username: "duplicate")
    duplicate_user = FactoryGirl.build(:user, username: "duplicate")
    expect(duplicate_user.save).to be_false
    expect(duplicate_user.errors[:username]).to include("has already been taken")
  end

  context "when student" do
    let(:student) { FactoryGirl.create(:user) }

    it "returns the correct disposition of the user" do
      expect(student.superadmin?).to be_false
    end
  end

  context "when superadmin" do
    let(:superadmin) { FactoryGirl.create(:superadmin) }

    it "returns the correct disposition of the user" do
      expect(superadmin.superadmin?).to be_true
    end
  end

  describe 'has a lesson completion status' do
    let(:user)        { FactoryGirl.create(:user) }
    let(:lesson)      { FactoryGirl.create(:lesson) }
    let(:assignment)  { FactoryGirl.create(:assignment) }
    let(:challenge)   { FactoryGirl.create(:challenge) }

    before(:each) do
      FactoryGirl.create(:activity, completable: assignment, position: 1)
      FactoryGirl.create(:activity, completable: challenge, position: 2)
    end

    it 'returns false if not completed' do
      expect(user.lesson_completed?(lesson)).to be_false
    end

    it 'returns true if completed' do
      FactoryGirl.create(:enrollment, user: user, lesson: lesson)
      FactoryGirl.create(:coursework, user: user, assignment: assignment,
                         completed: true)
      FactoryGirl.create(:challenge_completion, user: user, challenge: challenge)
      user.reload
      expect(user.lesson_completed?(lesson)).to be_true
    end
  end

end

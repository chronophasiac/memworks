require 'spec_helper'

describe Seeders::Dummy::Lessons do

  let(:seeder)      { Seeders::Dummy::Lessons }
  let(:lessons)     { seeder.seed }
  let(:challenges)  { lessons.first.activities.where(completable_type: "Challenge") }
  let(:cards)       { challenges.first.completable.cards }

  it 'seeds lessons' do
    lesson_count = Lesson.count
    seeder.seed
    expect(Lesson.count).to be >(lesson_count)
  end

  it 'seeds multiple lessons' do
    lesson_count = Lesson.count
    seeder.seed(count: 3)
    expect(Lesson.count).to eql(lesson_count + 3)
  end

  it 'seeds associated assignments' do
    assignments_count = Assignment.count
    assignments = lessons.first.activities.where(completable_type: "Assignment")
    expect(Assignment.count).to be >(assignments_count)
    expect(assignments.count).to be >(0)
  end

  it 'seeds associated challenges' do
    challenges_count = Challenge.count
    seeder.seed
    expect(Challenge.count).to be >(challenges_count)
    expect(challenges.count).to be >(0)
  end

  it 'seeds cards associated with challenges' do
    cards_count = Card.count
    seeder.seed
    expect(Card.count).to be >(cards_count)
    expect(cards.count).to be >(0)
  end

  it 'seeds cards with text and clickable responses' do
    seeder.seed
    str = false
    pos = false
    cards.each do |card|
      str = true if card.solution_type == "string"
      pos = true if card.solution_type == "position"
    end
    expect(str).to be_true
    expect(pos).to be_true
  end

  it 'can be run multiple times without duplication' do
    seeder.seed
    lesson_count = Lesson.count
    seeder.seed
    expect(Lesson.count).to eql(lesson_count)
  end

end

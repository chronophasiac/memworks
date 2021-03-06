require 'spec_helper'

describe Sm2Instance do
  describe "has spaced repetition methods" do
    let(:sm2) { Sm2Instance.new }

    it 'should initialize values' do
      sm2.easiness_factor.should == 2.5  
      sm2.number_repetitions.should == 0  
      sm2.repetition_interval.should == nil  
      sm2.quality_of_last_recall.should == nil  
      sm2.next_repetition.should == nil
      sm2.last_studied.should == nil
    end
    
    it 'should schedule next repetition for tomorrow if repetition_interval = 0 and quality_of_last_recall = 4' do
      sm2.process_recall_result(4)
      
      sm2.number_repetitions.should == 1
      sm2.repetition_interval.should == 1
      sm2.last_studied.should == Date.today
      sm2.next_repetition.should == (Date.today + 1)
      sm2.easiness_factor.should be_within(0.01).of(2.5)
    end

    it 'should schedule next repetition for 6 days if repetition_interval = 1 and quality_of_last_recall = 4' do
      sm2.process_recall_result(4)
      sm2.last_studied = Date.today - 1
      sm2.process_recall_result(4)
      
      sm2.number_repetitions.should == 2
      sm2.repetition_interval.should == 6
      sm2.last_studied.should == Date.today
      sm2.next_repetition.should == (Date.today + 6)
      sm2.easiness_factor.should be_within(0.01).of(2.5)
    end
    
    it 'should report as scheduled to recall (for today)' do
      sm2.next_repetition = Date.today
      sm2.scheduled_to_recall?.should == true

      sm2.next_repetition = Date.today - 1
      sm2.scheduled_to_recall?.should == true
    end
    
    it 'should not be scheduled to recall' do
      sm2.next_repetition = nil
      sm2.scheduled_to_recall?.should == false

      sm2.next_repetition = Date.today + 1
      sm2.scheduled_to_recall?.should == false

      sm2.next_repetition = Date.today + 99
      sm2.scheduled_to_recall?.should == false
    end
    
    it 'should require repeating items that scored 3' do
      sm2.process_recall_result(3)
      sm2.next_repetition.should == Date.today
      sm2.last_studied = Date.today - 1

      sm2.process_recall_result(3)
      sm2.next_repetition.should == Date.today
      sm2.last_studied = Date.today - 1

      sm2.process_recall_result(4)
      sm2.next_repetition.should == Date.today + 1
    end

    context 'when processing a card submission log' do
      let(:correct_log)   { FactoryGirl.create(:card_submission_log, correct: true) }
      let(:incorrect_log) { FactoryGirl.create(:card_submission_log, correct: false) }

      it "returns a next repetition date" do
        sm2.process_log(correct_log)
        expect(sm2.next_repetition).to be_a(Date)
      end

      it "returns a date in the future if the log indicated a correct response" do
        sm2.process_log(correct_log)
        expect(sm2.next_repetition).to be >(Date.today)
      end

      it "returns a closer date for incorrect responses than correct responses" do
        correct_sm2 = Sm2Instance.new
        incorrect_sm2 = Sm2Instance.new
        correct_sm2.process_log(correct_log)
        incorrect_sm2.process_log(incorrect_log)
        expect(correct_sm2.next_repetition).to be >(incorrect_sm2.next_repetition)
      end
    end
  end

end

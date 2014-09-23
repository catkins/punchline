require 'spec_helper'

module Punchline
  describe MinQueue do
    TEST_KEY = 'punchline:test:queue'

    def clear_queue!
      Redis.new.del TEST_KEY
    end

    before(:all) { clear_queue! }
    after(:each) { clear_queue! }

    let(:some_key) { TEST_KEY }
    subject(:min_queue) { MinQueue.new some_key }


    it { should_not be_nil }
    it { should respond_to :config }

    describe '#redis' do
      it { should respond_to :redis }

      it 'should not be nil' do
        expect(subject.redis).not_to be_nil
      end

      it 'should be equal to config#redis' do
        config = min_queue.config
        expect(min_queue.redis).to eq config.redis
      end
    end

    describe '#key' do
      it { should respond_to :key }

      it 'matches the constructor params' do
        expect(min_queue.key).to eq some_key
      end
    end

    describe '#length' do
      it { should respond_to :length }

      let(:mock_redis) { double 'redis', zcard: 5, del: true }

      it 'is initially zero' do
        expect(subject.length).to eq 0
      end

      it 'checks the cardinality of sorted set in redis' do
        subject.config.redis = mock_redis
        expect(mock_redis).to receive(:zcard).with(some_key)
        subject.length
      end

      it 'returns the length of the sorted set' do
        subject.config.redis = mock_redis
        expect(subject.length).to eq 5
      end
    end

    describe '#all' do
      it { should respond_to :all }

      it 'delegates to reading redis range' do
        expect(subject.redis).to receive(:zrange).with(some_key, 0, -1, with_scores: true)
                                                 .and_return([])
        subject.all
      end

      it 'returns an array' do
        expect(subject.all).to be_kind_of Array
      end

      it 'returns elements as hashes' do
        subject.enqueue priority: 123, value: 'hello'

        hash = subject.all.first
        expect(hash).not_to be_nil
        expect(hash[:priority]).to eq 123
        expect(hash[:value]).to eq 'hello'
      end
    end

    describe '#enqueue' do
      after(:each) do
        subject.reset_scripts!
      end

      it { should respond_to :enqueue }

      it 'increases the length by 1' do
        expect {
          subject.enqueue priority: 123, value: 'hello'
        }.to change {
          subject.length
        }.by 1
      end

      it 'returns true when key is written' do
        result = subject.enqueue priority: 123, value: 'hello'
        expect(result).to eq true
      end

      it 'returns false when key is not written' do
        result = subject.enqueue priority: 123, value: 'hello'
        result = subject.enqueue priority: 456, value: 'hello'
        expect(result).to eq false
      end

      describe 'duplicates' do
        it 'ignores duplicate values' do
          subject.enqueue priority: 123, value: 'hello'

          expect {
            subject.enqueue priority: 567, value: 'hello'
          }.to change {
            subject.length
          }.by(0)
        end

        it 'retains only the lowest priority score' do
          subject.enqueue priority: 123, value: 'hello'
          subject.enqueue priority: 567, value: 'hello'
          subject.enqueue priority: 789, value: 'hello'

          pair = subject.dequeue
          expect(pair[:priority]).to eq 123
        end
      end
    end

    describe '#dequeue' do
      after(:each) do
        subject.reset_scripts!
        subject.clear!
      end

      it { should respond_to :dequeue }

      it 'decreases the length by 1' do
        subject.enqueue priority: 123, value: 'hello'

        expect{ subject.dequeue }.to change { subject.length }.by -1
      end

      it 'returns the pair with the lowest score' do
        subject.enqueue priority: 123, value: 'hello'
        subject.enqueue priority: 567, value: 'world'
        expect(subject.dequeue).to eq({ value: 'hello', priority: 123 })
      end
    end

    describe '#clear!' do
      it { should respond_to :clear! }

      it 'deletes the key on redis' do
        expect(subject.redis).to receive(:del).with(some_key)
        subject.clear!
      end

      it 'resets the length' do
        subject.enqueue priority: 123, value: 'hello'
        expect { subject.clear! }.to change { subject.length }.by -1
      end
    end
  end
end

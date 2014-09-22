require 'spec_helper'

module Mindy
  describe MinQueue do

    let(:some_key) { 'some:key' }
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

      let(:mock_redis) { double 'redis', zcard: 5 }
      before(:each) { subject.config.redis = mock_redis }

      it { should respond_to :length }

      it 'checks the cardinality of sorted set in redis' do
        expect(mock_redis).to receive(:zcard).with(some_key)
        subject.length
      end

      it 'returns the length of the sorted set' do
        expect(subject.length).to eq 5
      end
    end

    describe '#enqueue' do
      after(:each) do
        subject.reset_scripts!
        subject.clear!
      end

      it { should respond_to :enqueue }

      it 'increases the length by 1' do
        expect {
          subject.enqueue priority: 123, value: 'hello'
        }.to change {
          subject.length
        }.by 1
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
  end
end

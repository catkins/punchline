require 'spec_helper'

module Mindy
  describe MinQueue do
    let(:key) { 'some:key' }

    subject(:min_queue) { MinQueue.new key }

    it { should_not be_nil }
    it { should respond_to :config }

    describe '#redis' do
      it { should respond_to :key }

      it 'should be equal to config#redis' do
        config = min_queue.config
        expect(min_queue.redis).to eq config.redis
      end
    end

    describe '#key' do
      it { should respond_to :key }

      it 'matches the constructor params' do
        expect(min_queue.key).to eq key
      end
    end

    describe '#length' do
      let(:mock_redis) { double 'redis', zcard: 5 }
      before(:each) { subject.config.redis = mock_redis }

      it { should respond_to :length }

      it 'checks the cardinality of sorted set in redis' do
        expect(mock_redis).to receive(:zcard).with(key)
        subject.length
      end

      it 'returns the length of the sorted set' do
        expect(subject.length).to eq 5
      end
    end

    describe '#enqueue' do
      it { should respond_to :enqueue }
    end

    describe '#dequeue' do
      it { should respond_to :dequeue }
    end
  end
end

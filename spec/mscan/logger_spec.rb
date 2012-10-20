require 'spec_helper'

describe Mscan::Logger do

  context 'measure' do
    it 'should call the given block' do
      stub = stub(Object)
      stub.should_receive(:something)
      Mscan::Logger.measure {  stub.something }
    end

    it 'should return the result of the block call' do
      result = Mscan::Logger.measure { 2 + 2 }
      result.should_not be_empty
      result.first.should == 4
    end

    context 'when verbose = true' do
      before do
        Configuration.for('app') do
          verbose true
        end
      end

      after do
        Configuration.for('app') do
          verbose false
        end
      end

      it 'should print the name' do
        Mscan::Logger.logger.should_receive(:info).with(/some name/)
        Mscan::Logger.measure('some name') { 2 + 2 }
      end

      it "should print 'the block'" do
        Mscan::Logger.logger.should_receive(:info).with(/the block/)
        Mscan::Logger.measure { 2 + 2 }
      end
    end

    context 'when verbose = false' do
      it 'should not print the name' do
        $stdout.should_not_receive(:puts).with(/some name/)
        Mscan::Logger.measure('some name') { 2 + 2 }
      end

      it "should not print 'the block'" do
        $stdout.should_not_receive(:puts).with(/the block/)
        Mscan::Logger.measure { 2 + 2 }
      end
    end

    # TODO write a test that measures the exact elapsed time
    it 'should return the total time' do
      expected_total_time = 0.03
      start_time = Timecop.travel
      result = Mscan::Logger.measure { sleep(expected_total_time) }
      result.should_not be_empty
      result.last.should be_within(0.01).of(expected_total_time)
    end
  end
end
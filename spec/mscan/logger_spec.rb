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

    it 'should print begin and finish with the provided message' do
      Mscan::Logger.logger.should_receive(:info).with('Begin some name...')
      Mscan::Logger.logger.should_receive(:info).with(/Finished some name in/)

      Mscan::Logger.measure('some name') { 2 + 2 }
    end

    it "should print 'the block' if no message is provided" do
      Mscan::Logger.logger.should_receive(:info).with('Begin ...')
      Mscan::Logger.logger.should_receive(:info).with(/Finished the block in/)

      Mscan::Logger.measure { 2 + 2 }
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
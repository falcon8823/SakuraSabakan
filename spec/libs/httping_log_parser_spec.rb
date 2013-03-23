require "spec_helper"

describe HttpingLogParser do
  let(:log) { nil }
  subject { HttpingLogParser.new(log) }

  context 'with normal input' do
    let(:log) {
      <<-EOF
PING falconsrv.net:80 (falconsrv.net):
connected to 219.94.234.63:80 (215 bytes), seq=0 time=126.69 ms 200 OK
connected to 219.94.234.63:80 (215 bytes), seq=1 time=54.30 ms 200 OK
connected to 219.94.234.63:80 (215 bytes), seq=2 time=45.45 ms 200 OK
connected to 219.94.234.63:80 (215 bytes), seq=3 time=47.38 ms 200 OK
connected to 219.94.234.63:80 (215 bytes), seq=4 time=49.15 ms 200 OK
--- falconsrv.net ping statistics ---
5 connects, 5 ok, 0.00% failed, time 324ms
round-trip min/avg/max = 45.5/64.6/126.7 ms
      EOF
    }

    describe '#rtt' do
      it "returns parsed RTT of log" do
        subject.rtt.should == {min: 45.5, avg: 64.6, max: 126.7}
      end
    end

    describe '#stat' do
      it "returns parsed statistics of log" do
        subject.stat.should == {failed_rate: 0.0}
      end
    end

    describe '#status' do
      it "returns parsed statistics of log" do
        subject.status.should == {status: '200'}
      end
    end
  end


  context 'with packet lossed input' do
    let(:log) {
      <<-EOF
PING falconsrv.net:80 (falconsrv.net):
connected to 219.94.234.63:80 (215 bytes), seq=0 time=53.24 ms 200 OK
connected to 219.94.234.63:80 (215 bytes), seq=1 time=54.99 ms 200 OK
connected to 219.94.234.63:80 (215 bytes), seq=2 time=174.92 ms 200 OK
connected to 219.94.234.63:80 (215 bytes), seq=3 time=194.78 ms 200 OK
problem connecting to host: Network is down
--- falconsrv.net ping statistics ---
5 connects, 4 ok, 20.00% failed, time 4482ms
round-trip min/avg/max = 53.2/119.5/194.8 ms
      EOF
    }

    describe '#rtt' do
      it "returns parsed RTT of log" do
        subject.rtt.should == {min: 53.2, avg: 119.5, max: 194.8}
      end
    end

    describe '#stat' do
      it "returns parsed statistics of log" do
        subject.stat.should == {failed_rate: 20.0}
      end
    end

    describe '#status' do
      it "returns parsed statistics of log" do
        subject.status.should == {status: '200'}
      end
    end
  end


  context 'with error input' do
    let(:log) {
      <<-EOF
PING falconsrv.net:80 (falconsrv.net):
No valid IPv4 or IPv6 address found for falconsrv.net


errno=0 which means Undefined error: 0 (if applicable)
      EOF
    }

    describe '#rtt' do
      it "returns parsed RTT of log" do
        subject.rtt.should == {min: 0, avg: 0, max: 0}
      end
    end

    describe '#stat' do
      it "returns parsed statistics of log" do
        subject.stat.should == {failed_rate: 100}
      end
    end

    describe '#status' do
      it "returns parsed statistics of log" do
        subject.status.should == {status: 'Failed'}
      end
    end
  end
end

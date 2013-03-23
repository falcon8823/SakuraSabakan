require 'spec_helper'

describe PingLogParser do
  let(:ping_log) { nil }
  subject { PingLogParser.new(ping_log) }


  context 'with normal input' do
    let(:ping_log) {
      <<-EOF
PING falconsrv.net (219.94.234.63): 56 data bytes
64 bytes from 219.94.234.63: icmp_seq=0 ttl=42 time=71.339 ms
64 bytes from 219.94.234.63: icmp_seq=1 ttl=42 time=34.438 ms
64 bytes from 219.94.234.63: icmp_seq=2 ttl=42 time=44.011 ms
64 bytes from 219.94.234.63: icmp_seq=3 ttl=42 time=18.750 ms
64 bytes from 219.94.234.63: icmp_seq=4 ttl=42 time=18.801 ms

--- falconsrv.net ping statistics ---
5 packets transmitted, 5 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 18.750/37.468/71.339/19.484 ms
      EOF
    }

    describe '#parse_rtt' do
      it "returns parsed RTT of log" do
        subject.parse_rtt.should == {min: 18.750, avg: 37.468, max: 71.339, stddev: 19.484}
      end
    end

    describe '#parse_stat' do
      it "returns parsed statistics of log" do
        subject.parse_stat.should == {transmitted: 5, received: 5, packet_loss: 0.0}
      end
    end
  end



  context 'with packet lossed input' do
    let(:ping_log) {
      <<-EOF
PING falconsrv.net (219.94.234.63): 56 data bytes
..Request timeout for icmp_seq 0
.Request timeout for icmp_seq 1
.Request timeout for icmp_seq 2
.Request timeout for icmp_seq 3

--- falconsrv.net ping statistics ---
5 packets transmitted, 1 packets received, 80.0% packet loss
round-trip min/avg/max/stddev = 53.895/53.895/53.895/0.000 ms
      EOF
    }

    describe '#parse_rtt' do
      it "returns parsed RTT of log" do
        subject.parse_rtt.should == {min: 53.895, avg: 53.895, max: 53.895, stddev: 0.000}
      end
    end

    describe '#parse_stat' do
      it "returns parsed statistics of log" do
        subject.parse_stat.should == {transmitted: 5, received: 1, packet_loss: 80.0}
      end
    end
  end



  context 'without input' do
    let(:ping_log) {
      ""
    }

    describe '#parse_rtt' do
      it "returns parsed RTT of log" do
        subject.parse_rtt.should == {min: 0.0, avg: 0.0, max: 0.0, stddev: 0.0}
      end
    end

    describe '#parse_stat' do
      it "returns parsed statistics of log" do
        subject.parse_stat.should == {transmitted: 0, received: 0, packet_loss: 100.0}
      end
    end
  end
end
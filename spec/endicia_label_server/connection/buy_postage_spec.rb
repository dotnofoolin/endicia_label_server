require 'spec_helper'
require 'tempfile'
require 'faker'

describe EndiciaLabelServer::Connection, '.buy_postage' do
  before do
    Excon.defaults[:mock] = true
  end

  after do
    Excon.stubs.clear
  end

  let(:stub_path) { File.expand_path("../../../stubs", __FILE__) }
  let(:server) { EndiciaLabelServer::Connection.new(test_mode: true) }

  context "when buying postage" do
    before do
      Excon.stub({:method => :post}) do |params|
        case params[:path]
          when "#{EndiciaLabelServer::Connection::ROOT_PATH}#{EndiciaLabelServer::Connection::BUY_POSTAGE_ENDPOINT}"
            {body: File.read("#{stub_path}/buy_postage_success.xml"), status: 200}
        end
      end
    end

    subject do
      server.buy_postage do |connection|
        connection.add :requester_id, ENV['ENDICIA_REQUESTER_ID']
        connection.add :request_id, 'ABC'
        connection.add :certified_intermediary, {
            account_id: '1234567',
            pass_phrase: 'SUPER SECRET AND SECURE PASSWORD',
            token: 'AGAIN ANOTHER AWESOME SECRET TOKEN'
        }
        connection.add recredit_amount: '5.00'
      end
    end

    it "should return postage balance" do
      expect { subject }.not_to raise_error
      expect(subject.postage_balance).to eql "5.00"
    end

    it "should return ascending balance" do
      expect { subject }.not_to raise_error
      expect(subject.ascending_balance).to eql "5.00"
    end

    it "should return account status" do
      expect { subject }.not_to raise_error
      expect(subject.account_status).to eql "A"
    end

    it "should return transaction id" do
      expect { subject }.not_to raise_error
      expect(subject.transaction_id).to eql "1.00"
    end
  end
end
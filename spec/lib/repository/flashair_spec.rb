require 'spec_helper'

describe FlashairDailyCopy::Repository::Flashair do
  let(:path) { '/DCIM/101OLYMP' }

  let(:hostname) { Faker::Internet.domain_name }
  let(:model) { described_class.new(hostname) }

  describe '.files' do
    let(:result)       { 'P9185137.JPG' }
    let(:api_url)      { model.url_for_files(path) }
    let(:api_response) { 'DCIM/101OLYMP,P9185137.JPG,1037953,32,18738,45457' }

    before do
      stub_request(:get, api_url).to_return(body: api_response)
    end

    subject { model.files(path).first.file_name }

    it 'should get expected result' do
      is_expected.to eq result
    end
  end

  describe 'datetime in CSV' do
    let(:date_val) { 18_743 }
    let(:time_val) { 41_029 }

    describe '.convert_datetime' do
      let(:result)   { DateTime.new(2016, 9, 23, 20, 2, 5) }

      subject { model.convert_datetime(date_val, time_val) }

      it { is_expected.to eq result }
    end

    describe '.parse_date' do
      let(:result) { [2016, 9, 23] }

      subject { model.parse_date(date_val) }

      it { is_expected.to eq result }
    end

    describe '.parse_time' do
      let(:result) { [20, 2, 5] }

      subject { model.parse_time(time_val) }

      it { is_expected.to eq result }
    end
  end
end

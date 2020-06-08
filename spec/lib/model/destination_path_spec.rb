require 'spec_helper'

describe FlashairDailyCopy::Model::DestinationPath do
  let(:file_name)   { 'P10000.JPG' }
  let(:datetime)    { DateTime.new(2020, 5, 31, 14, 35, 45) }
  let(:daily_image_path) { described_class.new(file_name, datetime) }

  describe '#file_path' do
    let(:dir_path) { '2020-05-31' }
    let(:result)   { "#{dir_path}/#{file_name}" }

    before do
      allow(daily_image_path).to receive(:dir_path).and_return(dir_path)
    end

    subject { daily_image_path.file_path }

    it { is_expected.to eq result }
  end

  describe '#dir_name' do
    let(:result) { datetime.strftime('%Y-%m-%d').to_s }

    subject { daily_image_path.dir_name }

    it { is_expected.to eq result }
  end
end

require 'spec_helper'
require 'timecop'
require_relative '../fetcher/fetcher_service'

describe 'Fetcher Service' do
  before do
    Timecop.freeze(Time.local(1990))
  end

  after do
    Timecop.return
  end

  it 'should manage normal file names' do
    filename = FetcherService.filename_from_path('image.jpg', 'image/jpeg')
    expect(filename).to eq('image.jpg')
  end

  it 'should manage file names without extension' do
    filename = FetcherService.filename_from_path('image', 'image/jpeg')
    expect(filename).to eq("#{Time.now.to_i}_image.jpeg")
  end

  it 'should manage file names without content-type' do
    filename = FetcherService.filename_from_path('image', '')
    expect(filename).to eq("#{Time.now.to_i}_image")
  end
end

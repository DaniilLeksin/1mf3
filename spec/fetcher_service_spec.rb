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

  context 'errors' do
    it 'should save single file into destination directory' do
      VCR.use_cassette('good_request') do
        url = 'https://i.redd.it/so5cg125lh001.jpg'
        expect do
          FetcherService.download_image(url, 'output', true)
        end.not_to raise_error
      end
    end

    it 'should raise TooManyRedirects' do
      VCR.use_cassette('error_to_many_redirects') do
        url = 'http://mywebserver.com/images/271947.jpg'
        expect do
          FetcherService.download_image(url, 'output', true)
        end.to raise_error(Down::TooManyRedirects)
      end
    end

    it 'should raise InvalidUrl' do
      url = 'jhhjkhgk'
      expect do
        FetcherService.download_image(url, 'output', true)
      end.to raise_error(Down::InvalidUrl)
    end

    it 'should raise ConnectionError' do
      url = 'http://somewebsrv.com/img/992147.jpg'
      stub_request(:any, url).to_timeout
      expect do
        FetcherService.download_image(url, 'output', true)
      end.to raise_error(Down::ConnectionError)
    end
  end

  context 'file naming' do
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

  context 'io' do
    it 'should handle if source file is absent' do
      expect do
        FetcherService.download('', 'output', true)
      end.to raise_error(Errno::ENOENT)
    end

    it 'should do nothing if source file is empty' do
      allow(FetcherService).to receive(:download_image)
      expect do
        FetcherService.download('data/empty.txt', 'output', true)
      end.not_to raise_error
      expect(FetcherService).not_to have_received(:download_image)
    end

    it 'should say YAY' do
      expect(FetcherService.hello_alice).to eq('\\(• ◡ •)// Yay!')
    end
  end
end

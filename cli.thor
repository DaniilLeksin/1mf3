require_relative 'fetcher/fetcher_service'

# Thor cli
class Cli < Thor
  desc 'say_hello', 'test it.'
  long_desc <<-LONGDESC
    \x5`thor cli:say_hello` tests if service is reachable. Some more long description.
    \n\n
  LONGDESC
  def say_hello
    FetcherService.hello_alice
  end

  desc 'download_single', 'download single URL.'
  long_desc <<-LONGDESC
    \x5`thor download_single --url URL --dest PATH` downloads content from given URL
    end stores it to DEST. 
    \n\n
  LONGDESC
  method_option :url, type: :string, default: nil, desc: 'path to file'
  method_option :dest, type: :string, default: nil, desc: 'path to output file'
  def download_single
    FetcherService.download_image(options[:url], options[:dest])
  end

  desc 'download', 'download from the SOURCE file.'
  long_desc <<-LONGDESC
    \x5`thor download --source SOURCE_PATH --dest PATH` read the file from SOURCE_PATH,
    downloads URLs and stores to PATH.
    end stores it in DEST path.
    \n\n
  LONGDESC
  method_option :source, type: :string, default: nil, desc: 'path to file'
  method_option :dest, type: :string, default: nil, desc: 'path to output file'
  def download
    FetcherService.download(options[:source], options[:dest])
  end
end

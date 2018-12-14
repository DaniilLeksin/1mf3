require 'down'

# FetcherService is a service ...
module FetcherService
  class << self
    def hello_alice
      p '\(• ◡ •)// Yay!'
    end

    def download(url, dest, test_mode = false)
      urls = File.readlines(url).map(&:strip)
      urls.each { |v| download_image(v, dest) }
    rescue StandardError => error
      raise error if test_mode

      p "[ERROR]: #{error.message}"
    end

    def download_image(url, destination, test_mode = false)
      tempfile = Down::NetHttp.download(url)
      filename = tempfile.original_filename
      # Monkeypatched Down::Utils.filename_from_path
      name = filename_from_path(filename, tempfile.content_type)
      path = "#{destination}/#{name}".gsub!(%r{/+}, '/')
      FileUtils.mv tempfile.path, path
    rescue StandardError => error
      raise error if test_mode

      p "[ERROR]: #{error.message} [FOR]: #{url}"
    end

    def generate_name(filename, extension)
      if extension.empty?
        "#{Time.now.to_i}_#{filename}"
      else
        "#{Time.now.to_i}_#{filename}.#{extension}"
      end
    end

    # Retrieves potential filename from the URL path.
    def filename_from_path(name, content_type)
      return "#{Time.now.to_i}_#{name}" if content_type.empty?

      extension = content_type.split('/').last
      filename = name.split('/').last
      alternative_name = generate_name(filename, extension)
      filename = File.extname(filename).empty? ? alternative_name : filename
      CGI.unescape(filename) if filename
    end
  end
end

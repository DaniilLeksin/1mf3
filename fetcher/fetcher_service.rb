require 'down'

# FetcherService is a service ...
module FetcherService
  class << self
    def hello_alice
      p '\(• ◡ •)// Yay!'
    end

    def content(url)
      File.readlines(url).map(&:strip)
    end

    def download(url, dest)
      urls = content(url)
      urls.each { |v| download_image(v, dest) }
    end

    def download_image(url, destination)
      tempfile = Down::NetHttp.download(url)
      filename = tempfile.original_filename

      # Monkeypatched Down::Utils.filename_from_path
      name = filename_from_path(filename, tempfile.content_type)
      # name = filename_from_path(filename, '')
      path = "#{destination}/#{name}".gsub!(%r{/+}, '/')
      FileUtils.mv tempfile.path, path
    rescue StandardError => error
      p error.message
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

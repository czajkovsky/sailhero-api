class Base64Decoder
  attr_accessor :image_data

  def initialize(data)
    @image_data = split(data)
  end

  def call
    return nil if image_data.nil?
    ActionDispatch::Http::UploadedFile.new(image_params)
  end

  private

  def image_params
    binary = Base64.decode64(image_data[:data])
    {
      filename: "data-uri.#{image_data[:extension]}",
      type: image_data[:type],
      tempfile: tmp_file(binary)
    }
  end

  def split(data)
    return nil unless data.match('^data:(.*?);(.*?),(.*)$')
    m = Regexp.last_match
    { type: m[1], encoder: m[2], data: m[3], extension: m[1].split('/')[1] }
  end

  def tmp_file(binary)
    file = Tempfile.new('data_uri-upload')
    file.binmode
    file << binary
    file.rewind
    file
  end
end

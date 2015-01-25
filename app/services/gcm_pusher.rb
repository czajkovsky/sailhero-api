class GCMPusher < OpenStruct
  def initializize(params)
    super params
  end

  def call
    return if devices.nil?
    options = { data: data, collapse_key: collapse_key }
    devices.each_slice(100).to_a.map { |group| gcm.send(group, options) }
  end

  private

  def gcm
    GCM.new(ENV['GCM_SECRET'])
  end
end

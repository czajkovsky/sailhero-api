class GCMPusher < OpenStruct
  def initializize(params)
    super params
  end

  def call
    options = { data: data, collapse_key: collapse_key }
    gcm.send(devices, options)
  end

  private

  def gcm
    GCM.new(ENV['GCM_SECRET'])
  end
end

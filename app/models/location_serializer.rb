class LocationSerializer
  def dump(location)
    return unless location
    ActiveSupport::JSON.encode(
      latitude: location[:latitude],
      longitude: location[:longitude]
    )
  end

  def load(value)
    return unless value
    hash = ActiveSupport::JSON.decode(value)
    Location.new(hash['latitude'], hash['longitude'])
  end
end

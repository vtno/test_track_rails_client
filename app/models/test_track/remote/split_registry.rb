class TestTrack::Remote::SplitRegistry
  include TestTrack::RemoteModel

  CACHE_KEY = 'test_track_split_registry'.freeze

  collection_path '/api/v1/split_registry'

  def self.fake_instance_attributes(_)
    ::TestTrack::Fake::SplitRegistry.instance.to_h
  end

  def self.instance
    # TODO: FakeableHer needs to make this faking a feature of `get`
    if faked?
      new(fake_instance_attributes(nil))
    else
      get('/api/v1/split_registry')
    end
  end

  def self.reset
    Rails.cache.delete(CACHE_KEY)
  end

  def self.to_hash
    if faked?
      instance.attributes.freeze
    else
      Rails.cache.fetch(CACHE_KEY, expires_in: 5.seconds) do
        instance.attributes
      end.freeze
    end
  rescue *TestTrack::SERVER_ERRORS => e
    Rails.logger.error "TestTrack failed to load split registry. #{e}"
    nil # if we can't get a split registry
  end
end

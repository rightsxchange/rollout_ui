module RolloutUi
  class Wrapper
    class NoRolloutInstance < ArgumentError; end

    attr_reader :rollout

    def initialize(rollout = nil)
      @rollout = rollout || RolloutUi.rollout
      raise NoRolloutInstance unless @rollout
    end

    def groups
      rollout.instance_variable_get("@groups").keys
    end

    def add_feature(feature)
      updating_features = features
      return if updating_features.include?(feature)
      updating_features << feature
      update_features(updating_features)
    end

    def remove_feature(feature)
      updating_features = features
      updating_features.delete(feature)
      update_features(updating_features)
    end

    def update_features(features_arr)
      features_string = features_arr.map(&:to_sym).sort.join(",")
      redis.set(@rollout.send(:features_key), features_string)
    end

    def features
      @rollout.features
    end

    def redis
      rollout.instance_variable_get("@storage")
    end
  end
end

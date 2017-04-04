class Hash
  def deep_underscore_keys
    deep_transform_keys do |key|
      if key.is_a? Symbol
        key.to_s.underscore.to_sym
      elsif key.is_a? String
        key.underscore
      end
    end
  end

  def deep_underscore_keys!
    replace(deep_underscore_keys)
  end
end

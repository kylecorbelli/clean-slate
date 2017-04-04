require 'rails_helper'

describe Hash do
  let :hash do
    # We have keys of both String and Symbol types since they both should be underscored:
    {
      theTask: {
        description: 'underscore all keys',
        'isDone' => false
      }
    }
  end

  let :underscored_hash do
    {
      the_task: {
        description: 'underscore all keys',
        'is_done' => false
      }
    }
  end

  describe 'deep_underscore_keys' do
    it 'should return a copy of the hash with all keys underscored' do
      result = hash.deep_underscore_keys
      expect(result).to eq(underscored_hash)
    end

    it 'should leave the original hash unaffected' do
      hash_clone = hash.clone
      hash.deep_underscore_keys
      expect(hash).to eq(hash_clone)
    end
  end

  describe 'deep_underscore_keys!' do
    it 'should return a copy of the hash with all keys underscored' do
      result = hash.deep_underscore_keys!
      expect(result).to eq(underscored_hash)
    end

    it 'should mutate the original hash' do
      underscored_hash_clone = underscored_hash
      hash.deep_underscore_keys!
      expect(hash).to eq(underscored_hash_clone)
    end
  end
end

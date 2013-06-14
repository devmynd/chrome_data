module ChromeData
  class Style < CollectionRequest
    class BodyType < Struct.new(:id, :name); end

    # These are only populated when accessing a style through a Vehicle
    attr_accessor :trim, :name_without_trim, :body_types

    def self.find_all_by_model_id(model_id)
      ChromeData.cache "#{request_name.underscore}-model_id-#{model_id}" do
        request 'modelId' => model_id
      end
    end

  end
end

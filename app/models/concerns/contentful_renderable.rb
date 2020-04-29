module ContentfulRenderable
  
  extend ActiveSupport::Concern

  def self.included(base)
    base.extend(ClassMethods)
  end

  # Overridable
  # Override this method to change the parameters set for your Contentful query on each specific model
  # For more information on queries you can look into: https://www.contentful.com/developers/docs/references/content-delivery-api/#/reference/search-parameters
  def render
    self.class.client.entries(content_type: self.class::CONTENT_TYPE, include: 2, "sys.id" => contentful_id).first
  end

  module ClassMethods
    
    def client
      @client ||= Contentful::Client.new(
        access_token: ENV["contentful_access_token"],
        space: ENV["contentful_space_id"],
        dynamic_entries: :auto,
        raise_errors: true,
        raise_for_empty_fields: false
      )
    end

    # Overridable
    # Override this method to change the parameters set for your Contentful query on each specific model
    # For more information on queries you can look into: https://www.contentful.com/developers/docs/references/content-delivery-api/#/reference/search-parameters
    def render_all(limit: 1000)
      client.entries(content_type: self::CONTENT_TYPE, include: 2, limit: limit)
    end
    
  end
  
end
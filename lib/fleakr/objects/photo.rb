module Fleakr
  module Objects # :nodoc:
    class Photo # :nodoc:

      include Fleakr::Support::Object

      flickr_attribute :title, :attribute => 'title'
      flickr_attribute :id, :attribute => 'id'
      flickr_attribute :farm_id, :attribute => 'farm'
      flickr_attribute :server_id, :attribute => 'server'
      flickr_attribute :secret, :attribute => 'secret'

      find_all :by_photoset_id, :call => 'photosets.getPhotos', :path => 'photoset/photo'
      find_all :by_user_id, :call => 'people.getPublicPhotos', :path => 'photos/photo'

      [:square, :thumbnail, :small, :medium, :large].each do |size|
        define_method(size) do
          Image.new(self.base_url, size)
        end
      end

      private
      def base_url
        "http://farm#{self.farm_id}.static.flickr.com/#{self.server_id}/#{self.id}_#{self.secret}"
      end

    end
  end
end
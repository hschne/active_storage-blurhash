module ActiveStorage
  module Blurhash
    module Thumbnail
      class Vips
        delegate_missing_to :@thumbnail

        def initialize(image)
          @thumbnail = ::Vips::Image.new_from_file(
            ::ImageProcessing::Vips.source(image.filename).resize_to_limit(200, 200).call.path
          )

          @thumbnail = case @thumbnail.bands
          when 1
            @thumbnail.bandjoin(Array.new(3 - @thumbnail.bands, @thumbnail))
          when 2
            @thumbnail.bandjoin(@thumbnail.extract_band(0))
          when 3
            @thumbnail
          else
            @thumbnail&.extract_band(0, n: 3)
          end
        end

        def pixels
          @thumbnail&.to_a&.flatten || []
        end
      end
    end
  end
end

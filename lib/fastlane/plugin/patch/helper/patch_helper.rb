module Fastlane
  module Helper
    class PatchHelper
      class << self
        def files_from_params(params)
          case params[:files]
          when Array
            params[:files].map(&:to_s)
          when String
            params[:files].split(",")
          else
            raise ArgumentError, "Invalid type #{params[:files].class} for :files option. Specify an Array or a String."
          end
        end
      end
    end
  end
end

require 'yaml'

module Fastlane
  module Actions
    class RevertPatchAction < Action
      def self.run(params)
        if params[:patch]
          # raises
          patch = YAML.load_file params[:patch]

          # If the :patch option is present, load these params from the
          # specified file. Action args override.
          %w{regexp text mode global}.each do |option|
            value = patch[option]
            next if value.nil?

            case option.to_sym
            when :regexp
              params[:regexp] = /#{value}/
            when :mode
              params[:mode] = value.to_sym
            else
              params[option.to_sym] = value
            end
          end
        end

        UI.user_error! "Must specify :regexp and :text either in a patch or via arguments" if
          params[:regexp].nil? || params[:text].nil?

        helper = Fastlane::Helper::PatchHelper
        helper.files_from_params(params).each do |file|
          modified_contents = File.open(file, "r") do |f|
            helper.revert_patch f.read,
                                params[:regexp],
                                params[:text],
                                params[:global],
                                params[:mode],
                                params[:offset]
          end

          File.open(file, "w") { |f| f.write modified_contents }
        end
      rescue => e
        UI.user_error! "Error in RevertPatchAction: #{e.message}\n#{e.backtrace}"
      end

      def self.description
        "Revert the action of apply_patch"
      end

      def self.authors
        ["Jimmy Dee"]
      end

      def self.details
        <<-EOF
Revert a patch by specifying the arguments provided to apply_patch
using arguments or the same YAML patch files.
        EOF
      end

      def self.example_code
        [
          <<-EOF
            revert_patch(
              files: "examples/PatchTestAndroid/app/src/main/AndroidManifest.xml",
              regexp: %r{^\s*</application>},
              mode: :prepend,
              text: "        <meta-data android:name=\"foo\" android:value=\"bar\" />\n"
            )
          EOF,
          <<-EOF
            revert_patch(
              files: "examples/PatchTestAndroid/app/src/main/AndroidManifest.xml",
              patch: "patch.yaml"
            )
          EOF
        ]
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :files,
                               description: "Absolute or relative path(s) to one or more files to patch",
                                  optional: false,
                                 is_string: false),
          FastlaneCore::ConfigItem.new(key: :regexp,
                               description: "A regular expression to match",
                                  optional: true,
                                      type: Regexp),
          FastlaneCore::ConfigItem.new(key: :text,
                               description: "Text used to modify to the match",
                                  optional: true,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :global,
                               description: "If true, patch all occurrences of the pattern",
                                  optional: true,
                             default_value: false,
                                 is_string: false),
          FastlaneCore::ConfigItem.new(key: :offset,
                               description: "Offset from which to start matching",
                                  optional: true,
                             default_value: 0,
                                      type: Integer),
          FastlaneCore::ConfigItem.new(key: :mode,
                               description: ":append or :prepend",
                                  optional: true,
                             default_value: :append,
                                      type: Symbol),
          FastlaneCore::ConfigItem.new(key: :patch,
                               description: "A YAML file specifying patch data",
                                  optional: true,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end

require 'pattern_patch'

module Fastlane
  module Actions
    class RevertPatchAction < Action
      def self.run(params)
        if params[:patch]
          patch = PatternPatch::Patch.from_yaml params[:patch]
        else
          patch = PatternPatch::Patch.new params
        end

        patch.revert params[:files], offset: params[:offset]
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

      def self.deprecated_notes
        <<-EOF
Please use the patch action with the :revert option instead.
        EOF
      end

      def self.category
        :deprecated
      end
    end
  end
end

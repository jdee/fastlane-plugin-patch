module Fastlane
  module Helper
    class PatchHelper
      class << self
        # Add the specified text after the specified pattern.
        # Returns a modified copy of the string.
        #
        # :contents: A string to modify, e.g. the contents of a file
        # :regexp: A regular expression specifying a pattern to be matched
        # :text: Text to be appended to the specified pattern
        # :global: Boolean flag. If true, patch all occurrences of the regex.
        # :prepend: Boolean flag. If true, prepend the text rather than appending it.
        # :offset: Starting position for matching
        def apply_patch(contents, regexp, text, global, prepend, offset)
          search_position = offset
          while (matches = regexp.match(contents, search_position))
            patched_pattern = prepend ? "#{text}#{matches[0]}" : "#{matches[0]}#{text}"
            contents = "#{matches.pre_match}#{patched_pattern}#{matches.post_match}"
            search_position = matches.pre_match.length + patched_pattern.length
            break unless global
          end
          contents
        end
      end
    end
  end
end

class String
  # Replace capture group references in self with appropriate
  # data from matches. Modifies the receiver. The receiver
  # need not match the matches.regexp.
  #
  # :matches: A MatchData object returned by Regexp#match
  def apply_matches!(matches)
    search_position = 0
    while (m = /\\(\d+)/.match(self, search_position))
      capture_group = m[1].to_i
      search_position = index m[0]
      gsub! m[0], matches[capture_group]
      search_position += matches[capture_group].length
    end
    nil
  end

  # Return a copy of the receiver with capture group references
  # in self replaced by appropriate data from matches. The receiver
  # need not match the matches.regexp.
  #
  # :matches: A MatchData object returned by Regexp#match
  def apply_matches(matches)
    string = clone
    string.apply_matches! matches
    string
  end
end

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
        # :mode: :append, :prepend or :replace to specify how to apply the patch
        # :offset: Starting position for matching
        def apply_patch(contents, regexp, text, global, mode, offset)
          search_position = offset
          while (matches = regexp.match(contents, search_position))
            patched_pattern =
              case mode
              when :append
                "#{matches[0]}#{text.apply_matches matches}"
              when :prepend
                "#{text.apply_matches matches}#{matches[0]}"
              when :replace
                matches[0].sub regexp, text
              else
                raise ArgumentError, "Invalid mode argument. Specify :append, :prepend or :replace."
              end

            contents = "#{matches.pre_match}#{patched_pattern}#{matches.post_match}"
            break unless global
            search_position = matches.pre_match.length + patched_pattern.length
          end
          contents
        end

        # Reverts a patch. Use the same arguments that were supplied to apply_patch.
        # The mode argument can only be :append or :prepend. Patches using :replace
        # cannot be reverted.
        # Returns a modified copy of the string.
        #
        # :contents: A string to modify, e.g. the contents of a file
        # :regexp: A regular expression specifying a pattern to be matched
        # :text: Text to be appended to the specified pattern
        # :global: Boolean flag. If true, patch all occurrences of the regex.
        # :mode: :append or :prepend. :replace patches cannot be reverted automatically.
        # :offset: Starting position for matching
        def revert_patch(contents, regexp, text, global, mode, offset)
          search_position = offset
          regexp_string = regexp.to_s

          patched_regexp =
            case mode
            when :append
              /#{regexp_string}#{text}/m
            when :prepend
              # TODO: Capture groups aren't currently revertible in :prepend mode.
              # This patched regexp can turn into something like /\1.*(\d+)/.
              # The capture group reference cannot occur in the regexp before definition
              # of the group. This would have to be transformed to something like
              # /(\d+).*\1/. Patch reversion is probably not a major use case right
              # now, so ignore for the moment.
              /#{text}#{regexp_string}/m
            else
              raise ArgumentError, "Invalid mode argument. Specify :append or :prepend."
            end

          while (matches = patched_regexp.match(contents, search_position))
            reverted_text = matches[0].sub(text.apply_matches(matches), '')
            contents = "#{matches.pre_match}#{reverted_text}#{matches.post_match}"
            break unless global
            search_position = matches.pre_match.length + reverted_text.length
          end

          contents
        end

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

# patch plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-patch)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-patch`, add it to your project by running:

```bash
fastlane add_plugin patch
```

## About patch

Apply and revert pattern-based patches to any text file.

```Ruby
apply_patch file: "examples/PatchTestAndroid/app/src/main/AndroidManifest.xml",
            regexp: %r{^\s*</application>},
            mode: :prepend,
            text: "        <meta-data android:name=\"foo\" android:value=\"bar\" />\n"
```

This action matches one or all occurrences of a specified regular expression and
modifies the file contents based on the optional `:mode` parameter. By default,
the action appends the specified text to the pattern match. It can also prepend
the text or replace the pattern match with the text. Use an optional `:global`
parameter to apply the patch to all instances of the regular expression.

The `regexp`, `text`, `mode` and `global` options may be specified in a YAML file to
define a patch, e.g.:

**patch.yaml**:
```yaml
regexp: '^\s*</application>'
mode: 'prepend'
text: "        <meta-data android:name='foo' android:value='bar' />\n"
global: false
```

**Fastfile**:
```Ruby
apply_patch file: "examples/PatchTestAndroid/app/src/main/AndroidManifest.xml",
            patch: "patch.yaml"
```

### Options

|key|description|type|optional|default value|
|---|-----------|----|--------|-------------|
|:file|Absolute or relative path to a file to patch|String|no| |
|:regexp|A regular expression to match|Regexp|yes| |
|:text|Text to append to the match|String|yes| |
|:global|If true, patch all occurrences of the pattern|Boolean|yes|false|
|:mode|:append, :prepend or :replace|Symbol|yes|:append|
|:offset|Offset from which to start matching|Integer|yes|0|
|:patch|A YAML file specifying patch data|String|yes| |

The :regexp and :text options must be set either in a patch file specified using the
:patch argument or via arguments in the Fastfile.

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

**Note to author:** Please set up a sample project to make it easy for users to explore what your plugin does. Provide everything that is necessary to try out the plugin in this project (including a sample Xcode/Android project if necessary)

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).

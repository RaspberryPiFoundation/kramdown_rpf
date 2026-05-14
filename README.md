# KramdownRPF

An extension to [Kramdown](https://kramdown.gettalong.org/) to add special markup for the RPF's learning platform.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kramdown-rpf'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kramdown-rpf

## Usage

``` ruby
require 'kramdown_rpf'

Kramdown::Document.new(markdown, input: 'KramdownRPF').to_html
```

KramdownRPF uses the Kramdown `GFM` markdown parser.

The syntax this library supports is defined in the specs:
* [Legacy `kramdown_rpf` specs](specs/fixtures/kramdown_rpf-legacy-spec.md)
* [Raspberry-flavoured Markdown draft specs](specs/fixtures/raspberry-flavoured-markdown-draft-spec.md)

### Quizzes (deprecated)

> [!WARNING]
> These are not in specs, and are due to be deprecated.

Quizzes can be added with choices for the user to select (currently only 1 mutually exclusive choice per quiz):
``` markdown
--- quiz ---
---
question: Here is a heading for a quiz with three possible answers. How do you feel?
---

- ( ) Great
- ( ) Okay
- ( ) Terrible

--- /quiz ---
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

### Testing against the specs

The specs live in `spec/fixtures` and any file whose name ends in `-spec.md` will be used as a test suite for this library.

```sh
bundle exec rspec
```

This is also run automatically in CI.

**NB** The canonical copies of the specs are in the [documentation repository](https://github.com/RaspberryPiFoundation/documentation) at `docs/technology/codebases-and-products/raspberry-flavoured-markdown/kramdown_rpf-legacy-spec.md`.  If you wish to change the output of the xamples in the specs, please update the canonical copy and then update the copy in this repository to match.

Currently this library tests our [legacy `kramdown_rpf` specs](https://digital-docs.rpf-internal.org/docs/technology/codebases-and-products/raspberry-flavoured-markdown/specs/kramdown_rpf-legacy-spec) as well as the newer [Raspberry-flavoured Markdown draft specs](https://digital-docs.rpf-internal.org/docs/technology/codebases-and-products/raspberry-flavoured-markdown/specs/raspberry-flavoured-markdown-draft-spec).

#### Tags in specs

Spec examples can be tagged in the following way:

````markdown
```example this-is-a-tag`
...
```
````

This allows you to run a subset of the specs by running:

```sh
bundle exec rspec --tag this-is-a-tag
```

There is a magic tag `not-kramdown` which is used to mark examples that are not expected to be supported by this library. This allows us to run the full set of specs and ensure that we are not accidentally supporting things we shouldn't be.

### Installing the gem locally

To install this gem onto your local machine, run `bundle exec rake install`.

### Release a new version

This gem is deployed from Github. To create a new release:

* Update the version number in [version.rb](./lib/kramdown_rpf/version.rb)
* git tag "vX.X.X" #for the relevant version
* git push origin --tags

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/RaspberryPiFoundation/kramdown_rpf. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

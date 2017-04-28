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

### Challenges

Within your markdown, add a challenge like this:
``` markdown
--- challenge ---

## Challenge: Improving your drum

+ Any markdown here

--- /challenge ---

```

### Collapsed content

Within your markdown, add some collapsed content (primarily ingredients) like this:
``` markdown
--- collapse ---
---
title: Downloading and installing the Raspberry Pi software
image: images/scratch.png
---

Content here comes from the ingredient.

--- /collapse ---
```

### Hints

Within your markdown, add some hints like this:
``` markdown
--- hints ---
--- hint ---

Hint 1

--- /hint ---
--- hint ---
Hint 2

--- /hint ---
--- hint ---

Hint 3
--- /hint ---
--- hint ---
Hint 4
--- /hint ---

--- /hints ---
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/RaspberryPiFoundation/kramdown_rpf. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

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

### Code block

When you want to include a code block, include the following in your Markdown

``` markdown
--- code ---
---
language: python # required
filename: whoopee.py # optional
line_numbers: true # optional - default false
line_number_start: 3 # optional - default 0
line_highlights: 3, 5-6 # optional
---
while True:
    button.wait_for_press()
    parp = random.choice(trumps)
    os.system("aplay {0}".format(parp))
    sleep(2)
--- /code ---
```

### Collapsed content

Within your markdown, add some collapsed content (primarily ingredients) like this:
``` markdown
--- collapse ---
---
title: Downloading and installing the Raspberry Pi software
---

Content here comes from the ingredient.

--- /collapse ---
```

### Print-specific content

When printing projects, we need to be able to hide that which on a screen would be interactive, and show a print fallback. Similarly we don't want to show the fallback content on screen where the interactive content is available. These two blocks will allow content editors to selectively show or hide content on screens and in print.

Content inside the following tags will NOT be shown when printed:
--- no-print ---
  This will not print
--- /no-print ---

...and content inside this block will ONLY be shown when printed, not on a screen:
--- print-only ---
  This will not show on screen, only in print
--- /print-only ---

To add a page break to printed content:
``` markdown
First page content

--- new-page ---

Second page content
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

To install this gem onto your local machine, run `bundle exec rake install`.

### Release a new version

This gem is deployed from Github. To create a new release:

* Update the version number in `version.rb`
* git tag "vX.X.X" #for the relevant version
* git push origin --tags

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/RaspberryPiFoundation/kramdown_rpf. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

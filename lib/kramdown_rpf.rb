require 'i18n'
require 'kramdown'

require_relative 'kramdown_rpf/version'
require_relative 'kramdown_rpf/kramdown'

I18n.load_path = Dir[File.join('locales', '*.yml')]
I18n.backend.load_translations


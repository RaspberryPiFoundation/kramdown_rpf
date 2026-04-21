# frozen_string_literal: true

require_relative 'lib/kramdown_rpf/version'

Gem::Specification.new do |spec|
  spec.name     = 'kramdown-rpf'
  spec.version  = KramdownRPF::VERSION
  spec.authors  = ['Raspberry Pi Foundation Digital Products Team']
  spec.email    = ['web@raspberrypi.org']
  spec.summary  = "Kramdown extensions for the Raspberry Pi Foundation's resources website."
  spec.homepage = 'https://projects.raspberrypi.org'
  spec.license  = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.pkg.github.com/RaspberryPiFoundation'
    spec.metadata['rubygems_mfa_required'] = 'true'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
          'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'i18n'
  spec.add_dependency 'kramdown', '~> 2.5'
  spec.add_dependency 'kramdown-parser-gfm'
end

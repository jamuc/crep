
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crep/version'

Gem::Specification.new do |spec|
  spec.name          = 'crep'
  spec.version       = Crep::VERSION
  spec.authors       = ['Kim Dung-Pham']
  spec.email         = ['kim.dung-pham@xing.com']

  spec.summary       = 'Create Crash Newsletter with ease.'
  spec.description   = 'Create Crash Newsletter with ease. Really.'
  spec.homepage      = ''
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'bin'
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.executables << 'crep'
  spec.require_paths = ['lib']

  spec.add_dependency 'hockeyapp'

  spec.add_runtime_dependency 'claide', '~> 1.0.0'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '0.51.0'
end


lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "simple_money/version"

Gem::Specification.new do |spec|
  spec.name          = "simple_money"
  spec.version       = SimpleMoney::VERSION
  spec.authors       = ["Michael Reinsch"]
  spec.email         = ["michael@movingfast.io"]

  spec.summary       = %q{Simple Money implementation}
  spec.homepage      = "https://github.com/mreinsch/simple_money"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end

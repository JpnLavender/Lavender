# -*- encoding: utf-8 -*-
# stub: slack-ruby-bot 0.8.2 ruby lib

Gem::Specification.new do |s|
  s.name = "slack-ruby-bot"
  s.version = "0.8.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Daniel Doubrovkine"]
  s.date = "2016-07-10"
  s.email = "dblock@dblock.org"
  s.homepage = "https://github.com/dblock/slack-ruby-bot"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "The easiest way to write a Slack bot in Ruby."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hashie>, [">= 0"])
      s.add_runtime_dependency(%q<slack-ruby-client>, [">= 0.6.0"])
      s.add_runtime_dependency(%q<giphy>, ["~> 2.0.2"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rack-test>, [">= 0"])
      s.add_development_dependency(%q<vcr>, [">= 0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
      s.add_development_dependency(%q<rubocop>, ["= 0.38.0"])
    else
      s.add_dependency(%q<hashie>, [">= 0"])
      s.add_dependency(%q<slack-ruby-client>, [">= 0.6.0"])
      s.add_dependency(%q<giphy>, ["~> 2.0.2"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<vcr>, [">= 0"])
      s.add_dependency(%q<webmock>, [">= 0"])
      s.add_dependency(%q<rubocop>, ["= 0.38.0"])
    end
  else
    s.add_dependency(%q<hashie>, [">= 0"])
    s.add_dependency(%q<slack-ruby-client>, [">= 0.6.0"])
    s.add_dependency(%q<giphy>, ["~> 2.0.2"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<vcr>, [">= 0"])
    s.add_dependency(%q<webmock>, [">= 0"])
    s.add_dependency(%q<rubocop>, ["= 0.38.0"])
  end
end

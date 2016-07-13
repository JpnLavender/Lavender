# -*- encoding: utf-8 -*-
# stub: slack-incoming-webhooks 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "slack-incoming-webhooks"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Shohei Yamasaki"]
  s.bindir = "exe"
  s.date = "2015-09-25"
  s.description = "A simple wrapper for posting to slack."
  s.email = ["s-yamasaki@pepabo.com"]
  s.homepage = "https://github.com/shoyan/slack-incoming-webhooks"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "A simple wrapper for posting to slack."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
    else
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
    end
  else
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
  end
end

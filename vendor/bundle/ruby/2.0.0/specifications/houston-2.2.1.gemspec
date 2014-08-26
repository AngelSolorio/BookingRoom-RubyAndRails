# -*- encoding: utf-8 -*-
# stub: houston 2.2.1 ruby lib

Gem::Specification.new do |s|
  s.name = "houston"
  s.version = "2.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Mattt Thompson"]
  s.date = "2014-08-13"
  s.description = "Houston is a simple gem for sending Apple Push Notifications. Pass your credentials, construct your message, and send it."
  s.email = "m@mattt.me"
  s.executables = ["apn"]
  s.files = ["bin/apn"]
  s.homepage = "http://nomad-cli.com"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.1"
  s.summary = "Send Apple Push Notifications"

  s.installed_by_version = "2.4.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<commander>, ["~> 4.1"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 3.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
    else
      s.add_dependency(%q<commander>, ["~> 4.1"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 3.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
    end
  else
    s.add_dependency(%q<commander>, ["~> 4.1"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 3.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
  end
end

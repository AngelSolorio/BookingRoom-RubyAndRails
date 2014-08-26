# -*- encoding: utf-8 -*-
# stub: fotoramajs 4.6.0 ruby lib

Gem::Specification.new do |s|
  s.name = "fotoramajs"
  s.version = "4.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Artem Polikarpov"]
  s.date = "2014-08-06"
  s.description = "Fotorama is a simple, stunning, powerful JavaScript gallery.  This is a gem, that allow you to simple install and maintain Fotorama in Rails Assets Pipeline."
  s.email = "fotoramajs@gmail.com"
  s.homepage = "http://fotorama.io/"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.1"
  s.summary = "Fotorama is a simple, stunning, powerful JavaScript gallery."

  s.installed_by_version = "2.4.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sprockets>, [">= 2"])
    else
      s.add_dependency(%q<sprockets>, [">= 2"])
    end
  else
    s.add_dependency(%q<sprockets>, [">= 2"])
  end
end

require 'houston'

  if Rails.env.production?
    APN = Houston::Client.production
    APN.certificate = File.read("#{::Rails.root}/lib/certificate_production.pem")
  else
    APN = Houston::Client.development
    APN.certificate = File.read("#{::Rails.root}/lib/certificate_development.pem")
  end
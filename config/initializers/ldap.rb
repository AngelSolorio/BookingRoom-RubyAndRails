require 'net/ldap'

LDAP = Net::LDAP.new
LDAP.host = "dc02.sellcom-solutions.com.mx"
LDAP.port = 389
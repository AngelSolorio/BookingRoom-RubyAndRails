require 'net/ldap'
require 'colorize'
ldap = Net::LDAP.new
email = "arturo.guerrero@gruposellcom.com"
ldap.host = "dc02.sellcom-solutions.com.mx"
ldap.port = 389
ldap.auth email, "abcde12345!"
if ldap.bind
  puts "Success #{ldap.inspect}".colorize(:yellow)
  # authentication succeeded
else
  # authentication failed
  puts "Error #{ldap.get_operation_result.message}".colorize(:yellow)
end

filter = Net::LDAP::Filter.eq("userprincipalname", email)
treebase = "dc=sellcom-solutions, dc=com,dc=mx"
ldap.search(:base => treebase, :filter => filter) do |entry|
    puts "DN: #{entry.dn}"
    entry.each do |attribute, values|
      puts "   #{attribute}:".colorize(:red)
      values.each do |value|
        puts "      --->#{value}".colorize(:white)
      end
    end
  end
  
unless ldap.bind
  puts "Result: #{ldap.get_operation_result.code}"
  puts "Message: #{ldap.get_operation_result.message}"
end

puts "LDAP #{ldap.search(:base => treebase, :filter => filter)}"
(ldap.search(:base => treebase, :filter => filter)).each {|entry| puts entry.displayname }
user=ldap.search(:base => treebase, :filter => filter)
puts "First Name #{user.first.givenname.first}"
puts "Last Name #{user.first.sn.first}"

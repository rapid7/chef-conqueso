require 'open-uri'
#result = open('https://github.com/rapid7/conqueso/releases/download/0.3.1/sha256sum.txt').read
result = open("https://github.com/rapid7/conqueso/releases/download/0.3.1/sha256sum.txt", :ssl_ca_cert=>"/etc/ssl/certs/ca-certificates.crt").read
puts result

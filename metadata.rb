name             'conqueso-chef'
maintainer       'Rapid7, LLC.'
maintainer_email 'eciramella@rapid7.com'
license          'Apache License'
description      'Installs/Configures the conqueso server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.5.0'

depends 'mysql', '4.0.20'
depends 'apt', '2.3.4'
depends 'build-essential', '1.4.2'
depends 'openssl', '1.1.0'
depends 'yum', '3.0.4'


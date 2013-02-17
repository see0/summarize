require 'mkmf'


RbConfig::MAKEFILE_CONFIG['CC'] = ENV['CC'] if ENV['CC']

ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
LIBDIR = RbConfig::CONFIG['libdir']
INCLUDEDIR = RbConfig::CONFIG['includedir']


$CFLAGS << " #{ENV["CFLAGS"]}"
$LIBS << " #{ENV["LIBS"]}"



  HEADER_DIRS = [
    # First search /opt/local for macports
    '/opt/local/include',

    # Then search /usr/local for people that installed from source
    '/usr/local/include',

    # Check the ruby install locations
    INCLUDEDIR,

    # Finally fall back to /usr
    '/usr/include',
    '/usr/include/libxml2',
  ]

  LIB_DIRS = [
    # First search /opt/local for macports
    '/opt/local/lib',

    # Then search /usr/local for people that installed from source
    '/usr/local/lib',

    # Check the ruby install locations
    LIBDIR,

    # Finally fall back to /usr
    '/usr/lib',
  ]

  XML2_HEADER_DIRS = [
    '/opt/local/include/libxml2',
    '/usr/local/include/libxml2',
    File.join(INCLUDEDIR, "libxml2")
  ] + HEADER_DIRS

  # If the user has homebrew installed, use the libxml2 inside homebrew
  brew_prefix = `brew --prefix libxml2 2> /dev/null`.chomp
  unless brew_prefix.empty?
    LIB_DIRS.unshift File.join(brew_prefix, 'lib')
    XML2_HEADER_DIRS.unshift File.join(brew_prefix, 'include/libxml2')
  end

dir_config('xml2', XML2_HEADER_DIRS, LIB_DIRS)

pkg_config('glib-2.0')
pkg_config('libiconv')



create_makefile('summarize/summarize')

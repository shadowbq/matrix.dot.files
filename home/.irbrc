begin
  # load wirble
  require 'irb/completion'
  require 'irb/ext/save-history'
  require 'rubygems'
rescue
  warn "Couldn't load irb history"
end
begin
  #%x{gem install 'wirble' --no-ri --no-rdoc} unless Gem::Specification::find_by_name('wirble')
  #Gem.refresh
  #require 'wirble'

  # start wirble (with color)
  #Wirble.init
  #Wirble.colorize

rescue LoadError => err
  warn "Couldn't load Wirble: #{err}"
end

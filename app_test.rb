
$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'init'

##inits 
main_loop = true
main_menu = Menu::Main.new

while(main_loop)

  result = main_menu.select_options
  main_loop = result.continue?

  



end







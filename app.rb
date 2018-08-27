
require_relative 'lib/menu/prompt'

$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'init'

##proto for menu

registry_client = Registry::Client.new

# registry_client.login?

choices_images = registry_client._catalog_v2.out['repositories']
choices_images << '<< Back'
image = Menu.prompt.select('Choose an image', choices_images )

# ##Return if not <<back

# ##let's go for tags
# registry_image = "image full name: #{RegistryAuth.configuration.registry}/#{image}"
# puts registry_image

# choices_images = registry_client.tags(image).out['tags']
# choices_images << '<< Back'

# tag = Menu.prompt.select('Choose a tag', choices_images )
# registry_image_full = "image full name: #{RegistryAuth.configuration.registry}/#{image}:#{tag}"
# puts registry_image_full
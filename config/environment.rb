# Load the Rails application.
require_relative 'application'

SETTINGS = YAML.load_file(File.join(Rails.root, 'config', 'settings.yml'))[Rails.env].deep_symbolize_keys!

# Initialize the Rails application.
Rails.application.initialize!

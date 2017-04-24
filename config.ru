require 'que/web'

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application

map '/que' do
  run Que::Web
end

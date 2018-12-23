require 'rack'
require 'capybara'
require 'capybara/rspec'

module NokogiriTestConfig
  module PATH
    Root = "site"
    Tutorials = "tutorials"
  end

  module CSS
    Header = "body > header"
    Footer = "body > footer"
    Nav = "nav"
  end
end

Capybara.app = Rack::Builder.app do
  use Rack::Static, root: NokogiriTestConfig::PATH::Root, index: "index.html"
  use Rack::Lint
  run(lambda { |env| [200, {'Content-Type'  => 'text/html'} ] })
end

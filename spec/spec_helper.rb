require 'rack'
require 'capybara'
require 'capybara/rspec'

module NokogiriTestConfig
  module PATH
    Root = "site"
    Tutorials = "tutorials"
  end

  module CSS
    Footer = "footer"
  end
end

Capybara.app = Rack::Builder.app do
  map "/" do
    use Rack::Static,
        :urls => ["/"],
        :root => NokogiriTestConfig::PATH::Root,
        :index => "index.html"
    use Rack::Lint
    run lambda {|env| [404, {}, '']}
  end
end

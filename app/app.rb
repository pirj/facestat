#coding: UTF-8
class Facestat < Padrino::Application
#  register SassInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers
  register Sinatra::Flash

  use Rack::Session::Pool
  enable :authentication
  use Rack::Protection
  disable :asset_stamp

  error do
    'Произошло нечто ужасное ' + env['sinatra.error'].name
  end

  [403, 404, 405, 500].each do |code|
    error code do
      render "errors/#{code}" #, :layout => 'errors/layout'
    end
  end
end

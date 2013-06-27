require 'sinatra'
require 'net/http'
require 'uri'

get '/:code' do
  @uri = redirect_uri(params[:code])
  if @uri
    erb :redirect
  else
    404
  end
end

def redirect_uri(code)
  uri = URI.parse "http://htn.to/#{code}"
  response = Net::HTTP.get_response(uri)
  if [301, 302].include?(response.code.to_i)
    response['Location'].sub %r[^http://b\.hatena\.ne\.jp/entry/], 'http://'
  else
    nil
  end
end

__END__

@@ redirect
<html>
  <head>
  <meta http-equiv="refresh" content="0; url=<%= @uri %>">
  </head>
</html>


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

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def redirect_uri(code)
  uri = URI.parse "http://htn.to/#{code}"
  response = Net::HTTP.get_response(uri)
  if [301, 302].include?(response.code.to_i)
    location = response['Location']
    base = "http://b\.hatena\.ne\.jp/entry/"
    if location =~ %r[^#{base}s/]
      location.sub %r[^#{base}s/], 'https://'
    else
      location.sub %r[^#{base}], 'http://'
    end
  else
    nil
  end
end

__END__

@@ redirect
<html>
  <head>
  <meta http-equiv="refresh" content="0; url=<%=h @uri %>">
  </head>
</html>


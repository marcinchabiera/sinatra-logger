require 'sinatra'
require 'htmlentities'
require 'json'
require 'erb'

get '/' do
  @list_of_requests = []
  Dir["#{File.dirname(__FILE__)}/requests/*"].sort_by {|f| File.mtime(f)}.each do |file_name|
    file_content = JSON.parse(File.read(file_name))
    @list_of_requests <<
        {
            method: HTMLEntities.new.decode(file_content["method"]),
            url: "#{file_content["url"]}",
            timestamp: File.mtime(file_name),
            ip: HTMLEntities.new.decode(file_content["ip"]),
            body: HTMLEntities.new.decode(file_content["body"]),
        }
  end
  status 200
  erb :index
end

get '/:req' do
  file_name = "#{File.dirname(__FILE__)}/requests/#{params['req']}"
  if File.exist?(file_name)
    @html = File.read(file_name)
    erb :index
  else
    status 404
    @error = "404 NOT FOUND"
    erb :index
  end
end

post '/:req' do

  # remove old files - older then Xh
  remove_old_files

  dir_name = 'requests'
  Dir.mkdir(dir_name) unless File.exists?(dir_name)
  file_content = '{'
  file_content << '"url":"' + HTMLEntities.new.encode(request.url) + '",'
  file_content << '"body":"' + HTMLEntities.new.encode(request.body.read) + '",'
  file_content << '"ip":"' + HTMLEntities.new.encode(request.ip) + '",'
  file_content << '"method":"' + HTMLEntities.new.encode(request.request_method) + '"'
  file_content << '}'
  File.write("#{dir_name}/#{params['req']}", "#{file_content}")
  status 201
  file_content
end

def remove_old_files
  hours = 1
  Dir["#{File.dirname(__FILE__)}/requests/*"].sort_by {|f| File.mtime(f)}.each do |file_name|
    File.delete(file_name) if (Time.now - File.ctime(file_name)) / 3600 > hours # 1h
  end
end

# request.body              # request body sent by the client (see below)
# request.scheme            # "http"
# request.script_name       # "/example"
# request.path_info         # "/foo"
# request.port              # 80
# request.request_method    # "GET"
# request.query_string      # ""
# request.content_length    # length of request.body
# request.media_type        # media type of request.body
# request.host              # "example.com"
# request.get?              # true (similar methods for other verbs)
# request.form_data?        # false
# request["SOME_HEADER"]    # value of SOME_HEADER header
# request.referer           # the referer of the client or '/'
# request.user_agent        # user agent (used by :agent condition)
# request.cookies           # hash of browser cookies
# request.xhr?              # is this an ajax request?
# request.url               # "http://example.com/example/foo"
# request.path              # "/example/foo"
# request.ip                # client IP address
# request.secure?           # false
# request.env               # raw env hash handed in by Rack
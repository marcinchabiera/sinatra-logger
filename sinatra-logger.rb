require 'sinatra'
require 'htmlentities'
require 'json'
require 'erb'

class App < Sinatra::Base

  get '/' do
    @list_of_requests = []
    Dir["#{File.dirname(__FILE__)}/requests/*-INFO*"].sort_by {|f| File.mtime(f)}.reverse.each do |file_name_info|
      request_file_info = parse_request_file_info(file_name_info)
      file_name_body = file_name_info.gsub(/-INFO/, '-BODY')
      request_file_info[:body] = File.read(file_name_body)
      @list_of_requests << request_file_info
    end
    status 200
    erb :index
  end

  get '/:req' do
    @list_of_requests = []
    req_tab = params['req'].split('.')
    record_number = req_tab.pop # remove last element and return this element
    req = req_tab.join('.')
    file_name_body = "#{File.dirname(__FILE__)}/requests/#{req}-BODY.#{record_number}"
    file_name_body = "#{File.dirname(__FILE__)}/requests/#{params['req']}-BODY" if !File.exist?(file_name_body)
    if File.exist?(file_name_body)
      status 200
      File.read(file_name_body)
    else
      @error = "404 NOT FOUND"
      status 404
      erb :index
    end
  end

  delete '/:req' do
    @list_of_requests = []
    file_name = "#{File.dirname(__FILE__)}/requests/#{params['req']}-INFO"
    if File.exist?(file_name)
      record_number = parse_request_file_info(file_name)[:record_number] - 1
      File.delete(file_name)
      file_name.gsub!(/-INFO/, '-BODY')
      file_body = File.read(file_name)
      File.delete(file_name)
      puts "#{record_number}"
      (1..record_number).each do |i|
        file_name = "#{File.dirname(__FILE__)}/requests/#{params['req']}-INFO.#{i}"
        puts "#{file_name}"
        File.delete(file_name)
        File.delete(file_name.gsub(/-INFO\./, '-BODY.'))
      end
      status 200
      file_body
    else
      @error = "404 NOT FOUND"
      status 404
      erb :index
    end
  end

  post '/:req' do
    # remove old files - older then Xh
    remove_old_files

    # Create requests folder if not exists
    dir_name = 'requests'
    Dir.mkdir(dir_name) unless File.exists?(dir_name)

    # Store old record in history
    record_number = 0
    file_name = "#{dir_name}/#{params['req']}-INFO"
    if File.exist?(file_name)
      record_number = parse_request_file_info(file_name)[:record_number]
      File.rename file_name, file_name + ".#{record_number}"
    end
    file_name = file_name.gsub!(/-INFO$/, '-BODY')
    if File.exist?(file_name)
      File.rename file_name, file_name + ".#{record_number}"
    end

    # REQ INFO
    record_number = record_number + 1
    file_content = '{'
    file_content << '"url":"' + HTMLEntities.new.encode(request.url) + '",'
    file_content << '"ip":"' + HTMLEntities.new.encode(request.ip) + '",'
    file_content << '"method":"' + HTMLEntities.new.encode(request.request_method) + '",'
    file_content << '"record_number":' << "#{record_number}"
    file_content << '}'
    File.write("#{dir_name}/#{params['req']}-INFO", "#{file_content}")

    # REQ BODY
    file_content = request.body.read
    File.write("#{dir_name}/#{params['req']}-BODY", "#{file_content}")

    status 201
    file_content
  end


  def parse_request_file_info(file_name)
    file_content = JSON.parse(File.read(file_name))
    {
        method: HTMLEntities.new.decode(file_content["method"]),
        url: "#{file_content["url"]}",
        timestamp: File.mtime(file_name),
        ip: HTMLEntities.new.decode(file_content["ip"]),
        record_number: file_content["record_number"],
    }
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
#
end
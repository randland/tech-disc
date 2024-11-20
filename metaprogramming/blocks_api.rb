class SomeAPI
  def initialize(root_url)
    @root_url = root_url
  end

  def authorize
    @auth = true
  end

  def open_connection
    @conn = Connection.new(root_url)
  end

  def close_connection
    @conn.send_closing_handshake
    @conn.log_session
    @conn.close
  end

  def get(path, **query)
    open_connection
    authorize

    Connection.call(URL.join(root_url, path, params: query)) do |conn|
      yield conn.result
    end
  ensure
    close_connection
  end
end

SomeAPI.new("mydomain.com").get('my_stats', id: 4) do |result|
  puts result.http_status
end

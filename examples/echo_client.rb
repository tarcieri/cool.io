require File.dirname(__FILE__) + '/../lib/rev'
#require 'rubygems'; require 'ruby-debug'; Debugger.start
ADDR = '127.0.0.1'
PORT = 4321

class ClientConnection < Rev::TCPSocket
  def on_connect
    puts "#{remote_addr}:#{remote_port} connected"
    write "bounce this back to me"
  end

  def on_close
    puts "#{remote_addr}:#{remote_port} disconnected"
  end

  def on_read(data)
    print "got #{data}"
    close
  end

  def on_resolve_failed
    print "DNS resolve failed"
  end

  def on_connect_failed
    print "connect failed, meaning our connection to their port was rejected"
  end

end

event_loop = Rev::Loop.default
client = ClientConnection.connect(ADDR, PORT)
client.attach(event_loop)
puts "Echo client connecting to #{ADDR}:#{PORT}..."
event_loop.run 

#--
# Copyright (C)2007 Tony Arcieri
# You can redistribute this under the terms of the Ruby license
# See file LICENSE for details
#++

require 'socket'
require File.dirname(__FILE__) + '/../rev'

module Rev
  class Listener < IOWatcher
    def initialize(listen_socket)
      @listen_socket = listen_socket
      super(@listen_socket)
    end

    # Called whenever the server receives a new connection
    def on_connection(socket); end
    event_callback :on_connection

    #########
    protected
    #########

    # Rev callback for handling new connections
    def on_readable
      on_connection @listen_socket.accept_nonblock
    end
  end

  class TCPListener < Listener
    DEFAULT_BACKLOG = 1024
    
    # Create a new Rev::TCPListener on the specified address and port.
    # Accepts the following options:
    #
    #  :backlog - Max size of the pending connection queue (default 1024)
    #  :reverse_lookup - Retain BasicSocket's reverse DNS functionality (default false)
    #
    def initialize(addr, port, options = {})
      BasicSocket.do_not_reverse_lookup = true unless options[:reverse_lookup]
      options[:backlog] ||= DEFAULT_BACKLOG
      
      listen_socket = ::TCPServer.new(addr, port)
      listen_socket.instance_eval { listen(options[:backlog]) }
      super(listen_socket)
    end
  end

  class UNIXListener < Listener
    # Create a new Rev::UNIXListener
    #
    # Accepts the same arguments as UNIXServer.new
    def initialize(*args)
      super(::UNIXServer.new(*args))
    end
  end
end

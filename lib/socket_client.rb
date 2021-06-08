require 'socket'

class SocketClient 
  attr_reader :socket
  attr_accessor :output

  def initialize(host,port)
    @socket = TCPSocket.new(host,port)
  end

  def provide_input(text)
    @socket.puts(text)
  end

  def capture_output(delay=0.1)
    sleep(delay)
    @output = socket.read_nonblock(1000).chomp # not gets which blocks
  rescue IO::WaitReadable
    @output = ""
  end

  def close
    @socket.close if @socket
  end
end


#CLIENT RUNNER SCRIPT

client = SocketClient.new('10.0.0.185',3336)
loop do 
  server_message = ""
  until server_message != ""
    server_message = client.capture_output
  end
  puts(server_message)
  if server_message.include?("do you want")
    client.provide_input(gets.chomp)
  end
end
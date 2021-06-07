require 'socket'
require_relative '../lib/socket_client'
describe "#SocketClient" do 

  before(:each) do
    @server = TCPServer.new(3336)
    @clients = []
  end

  after(:each) do
    @clients.each do |client|
        client.close
    end
    @server.close
  end

  context '#capture_output' do
    it 'recieves output from the server' do 
        client = SocketClient.new(3336)
        @clients.push(client)
        socket = @server.accept_nonblock
        socket.puts('welcome')
        expect(client.capture_output).to(eq('welcome'))
    end
  end
    context '#provide_input' do 
        it 'sends messages to the server' do 
            client = SocketClient.new(3336)
            @clients.push(client)
            socket = @server.accept_nonblock
            client.provide_input('hello world')
            expect(socket.gets.chomp).to(eq('hello world'))
        end
    end
end
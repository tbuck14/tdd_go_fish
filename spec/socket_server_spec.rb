require 'socket'
require_relative '../lib/socket_server'

describe SocketServer do
  before(:each) do
    @clients = []
    @server = SocketServer.new
    @server.start
  end

  after(:each) do
    @clients.each do |client|
      client.close
    end
    @server.stop
  end

  def make_client()
    client = TCPSocket.new('localhost',3336)
    @clients.push(client)
    client
  end

  it "is not listening on a port before it is started"  do
    @server.stop #had to stop the server before testing, becuase in my before each I make and start the server everytime
    expect {SocketClient.new(@server.port_number)}.to raise_error(Errno::ECONNREFUSED)
  end

  it 'accepts new clients' do 
    client = make_client
    @server.accept_new_client
    expect(@server.players.count).to(eq(1))
  end

  it 'sends messages to the client' do  
    client = make_client
    socket = @server.accept_new_client
    client.gets
    @server.provide_input(socket,'welcome')
    expect(client.gets.chomp).to(eq('welcome'))
  end

  it 'recieves messages from client' do  
    # client1 = make_and_accept_client
    # client2 = make_and_accept_client
    # game = @server.create_game_if_possible
    # client1.provide_input('hello craig')
    # @server.capture_output(game,'player1')
    # expect(@server.output).to(eq('hello craig'))
  end
end
require 'socket'
require_relative 'go_fish_game'
require_relative 'go_fish_player'
require_relative 'card_deck'
require_relative 'playing_card'
require_relative 'player_interfacing'



class SocketServer
    attr_reader :games, :players, :output, :game_with_players
  def initialize
    @games = []
    @players = [] 
    @game_with_players = {}
  end

  def port_number
    3336
  end

  def start
    puts "Server Started!"
    @server = TCPServer.new(port_number)
  end

  def stop
    @server.close if @server
  end

  def accept_new_client(player_name = "Random Player")
    client = @server.accept_nonblock
    player = PlayerInterfacing.new(GoFishPlayer.new(player_name),client)
    @players.push(player)
    player.client.puts("Welcome to go fish! you are #{player_name}")
    puts "Client #{player_name} Connected!"
    return client
    # associate player and client
  rescue IO::WaitReadable, Errno::EINTR
    #puts "No client to accept"
  end

  def create_game_if_possible
  end
  
  def provide_input(client,message)
    client.puts(message)
  end
  #pass in the game and player'
  def capture_output(game,player)
     sleep(0.1)
     @output = @game_with_players[game][player].client.read_nonblock(1000).chomp 
     rescue IO::WaitReadable
     @output = ""
  end

  def play_full_game(game)
  end

  def send_players_message(game,message)
  end

  def send_player_message_expect_response(game,player,message)
    @game_with_players[game][player].client.puts(message)
    output = ""
    until output != "" do 
      output = capture_output(game,player)
    end
    output
  end

end
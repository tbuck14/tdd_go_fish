require 'socket'
require_relative 'go_fish_game'
require_relative 'go_fish_player'
require_relative 'card_deck'
require_relative 'playing_card'
require_relative 'player_interfacing'



class SocketServer
    VALID_RANKS = ['2','3','4','5','6','7','8','9','10','J','Q','K','A']
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
        rescue IO::WaitReadable, Errno::EINTR
    end

    def create_game_if_possible
        if @players.length == 3
            game = GoFishGame.new(get_go_fish_players)
            @games.push(game)
            set_game_with_players(game)
            @players = []
            return game
        end
    end

    def play_full_game(game)
        until game.winner do
            @game_with_players[game].each do |name,player|
                ask_player_what_card(game,player) 
                send_players_message(game,game.round_info)
            end
        end
        puts "Winner: #{game.winner.name}"
    end

    def provide_input(client,message)
        client.puts(message)
    end

    def capture_output(game,player)
        sleep(0.1)
        @output = player.client.read_nonblock(1000).chomp 
        rescue IO::WaitReadable
        @output = ""
    end

    def get_go_fish_players()
        players = []
        @players.each do |playerInterface|
            players.push(playerInterface.player)
        end
        players
    end

    def set_game_with_players(game)
        @game_with_players[game] = {}
        player_number = 1
        @players.each do |playerInterface|
            @game_with_players[game]["player#{player_number}"] = playerInterface 
            player_number += 1
        end
    end

    def ask_player_what_card(game,playerInterface)
        provide_input(playerInterface.client,display_hand(playerInterface.player))
        # player_asked = @game_with_players[game][send_player_message_expect_response(game,playerInterface,"who do you want to ask? options: #{@game_with_players[game].keys}")].player    
        # card_asked_for = send_player_message_expect_response(game,playerInterface,"what card do you want to ask for? example '2' or 'A' ")
        player_asked = get_player_asked(game,playerInterface)
        card_asked_for = get_card_wanted(game,playerInterface)
        game_result = call_take_turn(game,playerInterface,card_asked_for,player_asked)
        ask_player_what_card(game,playerInterface) if game_result
    end

    def call_take_turn(game,playerInterface,card_asked_for,player_asked)
        game_output = game.player_take_turn(playerInterface.player,card_asked_for,player_asked)
        send_players_message(game, game.round_info)
        game.round_info = ""
        game_output
    end

    def get_player_asked(game,playerInterface)
        answer = send_player_message_expect_response(game,playerInterface,"who do you want to ask? options: #{@game_with_players[game].keys}")
        if @game_with_players[game].keys.include?(answer)
            return @game_with_players[game][answer].player
        else
            provide_input(playerInterface.client,'not a valid player!! try again')
            get_player_asked(game,playerInterface)
        end    
    end

    def get_card_wanted(game,playerInterface)
        answer = send_player_message_expect_response(game,playerInterface,"what card do you want to ask for? example '2' or 'A' ")
        if (VALID_RANKS.include?(answer) && display_hand(playerInterface.player).include?(answer))
            return answer
        else
            provide_input(playerInterface.client,'not a card you can ask for!! try again')
            get_card_wanted(game,playerInterface)
        end  
    end

    def send_players_message(game,message)
        @game_with_players[game].each do |name,player|
            provide_input(player.client,message)
        end
    end

    def send_player_message_expect_response(game,player,message)
        player.client.puts(message)
        output = ""
        until output != "" do 
            output = capture_output(game,player)
        end
        output
    end

    def display_hand(player)
        hand = 'YOUR HAND: '
        player.hand.each do |card|
            hand += "[#{card.rank}]"
        end
        hand
    end
end









#SERVER RUNNER SCRIPT
go_fish_server = SocketServer.new()
go_fish_server.start 
while true
    go_fish_server.accept_new_client("player #{go_fish_server.players.count + 1}")
    go_fish_game = go_fish_server.create_game_if_possible
    if go_fish_game
      Thread.new(go_fish_game) do |game|
        game.start
        go_fish_server.play_full_game(game)
      end
    end
end
war_server.players.each do |player|
    player.client.close
end
war_server.stop
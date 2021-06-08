require_relative '../lib/turn'

class GoFishGame 
    attr_reader :players, :deck, :books_layed
    attr_accessor :round_info
    def initialize(players)
        @players = players
        @deck = CardDeck.new
        @books_layed = 0 
        @round_info = ""
    end

    def deck()
        @deck
    end

    def players()
        @players
    end

    def add_to_books(number_of_books)
        @books_layed += number_of_books
    end

    def start()
        deck.shuffle
        players.each do |player|
            5.times do 
                player.take_cards([deck.deal])
            end
        end
    end

    def winner()
        return winning_player() if @books_layed == 13
    end

    #server asks player at the server level two questions before take turn is called at the server level
    def player_take_turn(player, card_asked_for, player_asked)
        try_to_lay_book(player)
        turn = Turn.new(player, card_asked_for, player_asked, @deck)
        turn.start_turn
        update_round_info(player,card_asked_for,player_asked,turn.got_card_asked_for)
        turn.got_card_asked_for
    end

    def winning_player
        winner = [players[0]]
        players.each do |player|
            winner = [player] if player.books.count > winner[0].books.count
            winner += [player] if player.books.count == winner[0].books.count
        end
        winner
    end

    def try_to_lay_book(player)
        if player.lay_book()
            @round_info += " #{player.name} has layed a book of #{player.books.last}, " 
            add_to_books(1)
        end
    end
    
    def update_round_info(player,card_asked_for,player_asked,did_get_card)
        got_card = "got one or more" if did_get_card
        got_card = "did not get it" if did_get_card == false
        @round_info += "#{player.name} asked for #{card_asked_for} from #{player_asked.name} and #{got_card}"
    end

end
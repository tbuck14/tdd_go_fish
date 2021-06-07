class GoFishGame 
    attr_reader :players, :deck
    def initialize(players)
        @players = players
        @deck = CardDeck.new
        @books_layed = 0 
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

    def player_take_turn(player)
        turn = Turn.new(player)
        turn.start_turn
    end

    def winning_player
        winner = [players[0]]
        players.each do |player|
            winner = [player] if player.books.count > winner[0].books.count
            winner += [player] if player.books.count == winner[0].books.count
        end
        winner
    end

end
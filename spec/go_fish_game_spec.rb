require_relative '../lib/go_fish_game'
require_relative '../lib/go_fish_player'
require_relative '../lib/playing_card'
describe '#GoFishGame' do 

    context '#start' do 
        it 'deals 5 cards to each player in the game' do 
            game = GoFishGame.new([GoFishPlayer.new('player1'),GoFishPlayer.new('player2'),GoFishPlayer.new('player3')])
            game.start
            expect(game.players[0].cards_left).to(eq(5))
            expect(game.players[1].cards_left).to(eq(5))
            expect(game.players[2].cards_left).to(eq(5))
        end
    end
    context '#winner' do 
        it 'returns true if all the books have been layed' do 
            game = GoFishGame.new([GoFishPlayer.new('player1',[PlayingCard.new('3','clubs'),PlayingCard.new('3','clubs'),PlayingCard.new('3','clubs'),PlayingCard.new('3','clubs')]),GoFishPlayer.new('player2'),GoFishPlayer.new('player3')])
            game.player_take_turn(game.players[0],'5',game.players[1])
            game.add_to_books(12)
            expect(game.books_layed).to(eq(13))
            expect(game.winner[0].name).to(eq(game.players[0].name))
        end
        it 'returns the winning player if all the books have been layed' do 
            game = GoFishGame.new([GoFishPlayer.new('player1'),GoFishPlayer.new('player2')])
            game.start
            expect(game.winner).to(eq(nil))
        end
    end

    

    context '#player_take_turn' do 
        it 'returns true if the player did get the card they wanted'do 
            player1 = GoFishPlayer.new('player1',[PlayingCard.new('3','clubs')])
            player2 = GoFishPlayer.new('player2',[PlayingCard.new('3','spades')])
            game = GoFishGame.new([player1,player2])
            expect(game.player_take_turn(player1,'3',player2)).to(eq(true))
            expect(player1.cards_left).to(eq(2))
            expect(player2.cards_left).to(eq(0))
        end

        it 'returns false if the player did not get the card they wanted'do 
            player1 = GoFishPlayer.new('player1',[PlayingCard.new('3','clubs')])
            player2 = GoFishPlayer.new('player2',[PlayingCard.new('2','spades')])
            game = GoFishGame.new([player1,player2])
            expect(game.player_take_turn(player1,'3',player2)).to(eq(false))
            expect(player1.cards_left).to(eq(2))
            expect(player2.cards_left).to(eq(1))
        end
        
        it 'lays a book if the player has one in their hand' do
            player1 = GoFishPlayer.new('trevor',[PlayingCard.new('A','spades'),PlayingCard.new('A','hearts'),PlayingCard.new('A','clubs'),PlayingCard.new('A','diamonds')])
            player2 = GoFishPlayer.new('player2',[PlayingCard.new('2','spades')])
            game = GoFishGame.new([player1,player2])
            game.player_take_turn(player1,'3',player2)
            expect(player1.books.count).to eq 1
        end
    end

    context '#try_to_lay_book' do 
        it 'adds book if a book can be layed' do 
            player1 = GoFishPlayer.new('trevor',[PlayingCard.new('A','spades'),PlayingCard.new('A','hearts'),PlayingCard.new('A','clubs'),PlayingCard.new('A','diamonds')])
            player2 = GoFishPlayer.new('player2',[PlayingCard.new('2','spades')])
            game = GoFishGame.new([player1,player2])
            game.try_to_lay_book(player1)
            expect(game.books_layed).to(eq(1))
        end
    end

end
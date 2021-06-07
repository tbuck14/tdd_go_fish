require_relative '../lib/go_fish_game'
require_relative '../lib/go_fish_player'
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
            game = GoFishGame.new([GoFishPlayer.new('player1'),GoFishPlayer.new('player2'),GoFishPlayer.new('player3')])
            game.start
            ['2','3','4','5','6','7','8','9','10','J','Q','K','A'].each {|rank| game.players[0].lay_book(rank)}
            game.add_to_books(13)
            expect(game.winner[0].name).to(eq(game.players[0].name))
        end
        it 'returns the winning player if all the books have been layed' do 
            game = GoFishGame.new([GoFishPlayer.new('player1'),GoFishPlayer.new('player2')])
            game.start
            expect(game.winner).to(eq(nil))
        end
    end

end
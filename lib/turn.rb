class Turn
    attr_accessor :player, :player_asked, :card_asked_for, :card_awarded, :deck
    def initialize(player,asked_card,playerAsked,deck)
        @player = player
        @player_asked = playerAsked
        @card_asked_for = asked_card
        @card_awarded = ""
        @deck = deck
    end
    
    def start_turn()
       won_cards = @player_asked.check_hand_for(@card_asked_for)
       if won_cards != nil 
            @card_awarded = won_cards.first
            @player.take_cards(won_cards)
       else
            go_fish() 
       end
    end

    def go_fish()
        if @deck.cards_left != 0 
            @card_awarded = @deck.deal
            @player.take_cards([@card_awarded])
        end
    end

    def got_card_asked_for()
        @card_awarded.rank == @card_asked_for
    end

end
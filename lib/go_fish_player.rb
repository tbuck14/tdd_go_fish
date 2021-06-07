class GoFishPlayer 
    attr_reader :cards_left, :name, :hand, :books
    def initialize(name, hand=[])
        @hand = hand
        @cards_left = @hand.count
        @name = name
        @books = []
    end
    
    def take_cards(cards) 
       cards.shuffle!
       @hand.unshift(cards).flatten!
       @cards_left += cards.count
    end

    def play_card()
        @cards_left -= 1
        @hand.pop()
    end

    def check_hand_for(rank)
        cards_to_return = []
        @hand.each {|card| cards_to_return.push(card) if card.rank == rank}
        @hand -= cards_to_return
        @cards_left -= cards_to_return.count
        return cards_to_return if cards_to_return.count != 0 
    end
    
    def lay_book(rank)
        @books.push(rank)
    end

end
class GoFishPlayer 
    attr_accessor :cards_left, :name, :hand, :books
    def initialize(name, hand=[])
        @hand = hand
        @cards_left = @hand.count
        @name = name
        @books = []
    end

    def take_cards(cards) 
       @hand.unshift(cards).flatten!
       @hand = @hand.sort_by {|card| card.value}
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
    
    def lay_book() 
        @hand.each do |card|
            if check_for_book(card.rank).count == 4
                @books.push(card.rank)
                return true
            end
        end
        false
    end

    def check_for_book(rank)
        cards_to_return = []
        @hand.each {|card| cards_to_return.push(card) if card.rank == rank}
        cards_to_return = check_hand_for(rank) if cards_to_return.count == 4
        cards_to_return 
    end

end
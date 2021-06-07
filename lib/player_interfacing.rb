class PlayerInterfacing 
    attr_reader :player, :client
    def initialize(player,client)
        @player = player
        @client = client
    end
end
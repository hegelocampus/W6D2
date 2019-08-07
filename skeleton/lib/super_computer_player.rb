require_relative 'tic_tac_toe_node'
require 'byebug'

# :x :n :n
# :o :n :n
# :x :o :n
class SuperComputerPlayer < ComputerPlayer
  def move(game, mark)
    node = TicTacToeNode.new(game.board, mark)
    childs = node.children #.shuffle
    
    non_lost = []
    winning = []

    childs.each do |child|
      next if child.losing_node?(mark)
      if child.winning_node?(mark)
        winning << child.prev_move_pos
      end
      #debugger
      non_lost << child.prev_move_pos
      #debugger
    end

    p winning
    p non_lost
    #raise "Something ain't right" if non_lost.empty? && winning.empty?
    winning[0] || non_lost.sample
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Play the brilliant computer!"
  hp = HumanPlayer.new("Jeff")
  cp = SuperComputerPlayer.new

  TicTacToe.new(hp, cp).run
end

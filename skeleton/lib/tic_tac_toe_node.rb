require_relative 'tic_tac_toe'

class TicTacToeNode
  attr_reader :board, :prev_move_pos
  attr_accessor :next_mover_mark

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    return true if board.winner == :x

    if evaluator == :x
      children.none? { |child| child.losing_node?(:x) }
    else
      children.any? { |child| child.losing_node?(:x) }
    end
  end

  def winning_node?(evaluator)

  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    poss_moves = []
    next_move = (next_mover_mark == :x ? :o : :x)

    board.rows.each_with_index do |row, idx1|
      row.each_with_index do |pos, idx2|
        next unless pos.nil?
        _new_board = board.dup
        _new_board[[idx1, idx2]] = self.next_mover_mark
        board_node = TicTacToeNode.new(_new_board, next_move, [idx1, idx2]) 
        poss_moves << board_node
      end
    end
    
    poss_moves
  end
end
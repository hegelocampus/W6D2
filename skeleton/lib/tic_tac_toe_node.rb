require_relative 'tic_tac_toe'
require 'byebug'

class TicTacToeNode
  attr_reader :board, :prev_move_pos
  attr_accessor :next_mover_mark

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  #eval == root_node_symbol
  #next_mover_mark == !root
  # CurrPlayer = P1 => :x (next_mover_mark)
  # Evaluator :x => any? child.losing_node?(:x)
  # Evaluator :o => all? child.losing_node?(:o)

  # CurrPlayer = P2 => :o (next_mover_mark)
  # Evaluator :x => all? child.losing_node?(:x)
  # Evaluator :o => any? child.losing_node?(:o)

  # def losing_node?(evaluator)
  #   return true if secret_switch?(evaluator)

  #   if evaluator == @next_mover_mark #players turn
  #     children.all? { |child| child.losing_node?(evaluator) }
  #   else #robot turn
  #     children.any? { |child| child.losing_node?(evaluator) }
  #   end
  # end

  def losing_node?(evaluator)
    queue = [self, self.children].flatten
    other_eval = ((evaluator == :x) ? :o : :x)

    until queue.empty?
      curr = queue.shift
      c_board = curr.board
      if c_board.over?
        return true unless c_board.winner == evaluator || c_board.tied?
      end
      return true if curr.children.any? { |child| child.board.winner == other_eval }
    end

    false
  end

  def winning_node?(evaluator)
    queue = [self, self.children, self.children.map(&:children)].flatten
    other_eval = ((evaluator == :x) ? :o : :x)

    until queue.empty?
      curr = queue.shift
      c_board = curr.board
      if c_board.over?
        return true unless c_board.winner == other_eval || c_board.tied?
      end
      return true if curr.children.any? { |child| child.board.winner == evaluator }
    end

    false
  end

  # def winning_node?(evaluator)
  #   return true if board.winner == evaluator

  #   if evaluator == @next_mover_mark #players turn
  #     children.all? { |child| child.winning_node?(evaluator) }
  #   else #robot turn
  #     children.any? { |child| child.winning_node?(evaluator) }
  #   end
  # end

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

  def inspect
    { "prev move pos" => prev_move_pos, "next mover mark" => next_mover_mark, "grid" => board }.inspect
  end

  private

  def secret_switch?(evaluator)
    if evaluator == :x
      if board.over?
        case board.winner
        when :o
          return true
        when :nil
          return false
        when :x
          return false
        end
      end
    elsif evaluator == :o
      if board.over?
        case board.winner
        when :o
          return false
        when :nil
          return false
        when :x
          return true
        end
      end
    end
  end
end
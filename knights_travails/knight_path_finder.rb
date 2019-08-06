require_relative 'polytree_node'
require 'byebug'

# todo: we need to build_move_tree; begins at root_node
#       call build_move_tree in initialize
#       need a find_path method; traverses the move_tree
#       method self.valid_moves(pos); up to 8 possible moves
#       avoid repeating positions in the move_tree
#       variable @considered_positions; tracks pos we considered
#            - initalize as array containing just the starting position
#       method new_move_positions(pos); calls valid_moves(pos)
#            - filter out any positions that are already in @considered_positions
#            - add remaining new positions to @considered_positions
#            - return new positions
#       method build_move_tree; use new_move_positions(pos)
#            - IMPORTANT: Build tree in breadth-first manner
#            - use queue to process nodes in FIFO order
#            - start with a root node and explore moves one position at a time
#       method build_move_tree
#            - queue << new_move_positions.map { |ele| Polytree_node.new(ele) }
#            - repeat on queue until queue.empty?
#       Then Code Review
#       Then Pt. 2

class Knight_path_finder
  attr_reader :root_node
  def initialize(pos)
    @root_node = Polytree_node.new(pos)
    @considered_positions = [pos]
    build_move_tree
  end

  def self.valid_moves(pos)
    m1, m2 = 1, 2
    x, y = pos[0], pos[1]
    [
     [x + m1, y + m2],
     [x + m1, y - m2],
     [x - m1, y + m2],
     [x - m1, y - m1],
     [x + m2, y + m1],
     [x + m2, y - m1],
     [x - m2, y + m1],
     [x - m2, y - m1]
    ].select { |pos| (0..7).cover?(pos[0]) && (0..7).cover?(pos[1]) }
  end

  def new_move_positions(pos)
    moves = self.class.valid_moves(pos).reject { |p| @considered_positions.include?(p) }
    @considered_positions += moves
    moves.map { |move| Polytree_node.new(move) }
  end

  def build_move_tree
    queue = [@root_node]

    until queue.empty?
      position = queue.shift
      queue += new_move_positions(position.value).each { |move| move.parent= position }
    end
  end

  def bfs(target)

    queue = [@root_node]

    until queue.empty?
      search = queue.shift
      return search if search.value == target
      queue += search.children
    end

  end

  private
end

# ▄  ▄  ▄  ▄  ▄  ▄  ▄  ▄
# ▄  ▄  ▄  ▄  ▄  ▄  ▄  ▄
# ▄  ▄  ▄  ▄  ▄  ▄  ▄  ▄
# ▄  ▄  ▄  2  E  2  ▄  2
# ▄  ▄  2  ▄  ▄  ▄  ▄  ▄
# ▄  2  ▄  ▄  1  ▄  1  ▄
# ▄  ▄  ▄  1  ▄  ▄  ▄  1
# ▄  2  ▄  ▄  ▄  S  ▄  ▄

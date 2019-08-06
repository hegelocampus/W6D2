require_relative 'polytree_node'
require 'byebug'


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

  def find_path(end_pos)
    trace_path_back(bfs(end_pos)).map { |node| node.value }
    ## This version returns positions rather than the node obj 
    #trace_path_back(bfs(end_pos)).map { |node| node.value }
  end

  def trace_path_back(node)
    path = [node]

    path << path[-1].parent until path[-1] == root_node

    path.reverse
  end

  private
end

if __FILE__ == $PROGRAM_NAME
  kpf = Knight_path_finder.new([0, 0])
  p kpf.find_path([7, 6]) # => [[0, 0], [1, 2], [2, 4], [3, 6], [5, 5], [7, 6]]
  p kpf.find_path([6, 2]) # => [[0, 0], [1, 2], [2, 0], [4, 1], [6, 2]]
end
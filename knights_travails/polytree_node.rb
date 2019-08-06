class Polytree_node
  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def parent
    @parent
  end

  def children
    @children
  end

  def value
    @value
  end

  def parent=(new_parent)
    @parent.children.delete(self) unless @parent.nil?

    @parent = new_parent

    @parent.children << self unless @parent.nil? || @parent.children.include?(self)
  end
  
  def add_child(child_node)
    children << child_node unless children.include?(child_node)
    child_node.parent=self
  end

  def remove_child(child_node)
    @parent.children.delete(child_node) unless @parent.nil?
    raise "Not a child" if child_node.parent.nil?
    child_node.parent=nil
  end

  def dfs(target)
    return self if @value == target

    all_children = []
    all_children += @children

    until all_children.empty? || all_children.first == target
      search = all_children.shift.dfs(target)
      return search unless search.nil?
    end

    all_children.first
  end

  def bfs(target)

    queue = [self]

    until queue.empty?
      search = queue.shift
      return search if search.value == target
      queue += search.children
    end

  end

  def inspect
    { "value" => value, "children" => @children.map { |el| el.value } }.inspect
  end
end
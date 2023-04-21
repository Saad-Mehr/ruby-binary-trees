class Node
  attr_accessor :data, :left, :right
  def initialize(value = nil)
    self.data = value
  end
end

class Tree
  attr_accessor :root

  def initialize(value = nil)
    self.root = Node.new(value)
  end

  def build_tree(array, node = self.root)
    return nil if (array == nil or array.length == 0)
    return Node.new(array[0]) if (array.length == 1)
    array = array.sort.uniq
    mid = (array.length / 2)
    node.data = array[mid]

    node.left = build_tree(array.slice(0, array.length / 2), Node.new())
    node.right =
      build_tree(array.slice(mid + 1, array.length / 2 + 1), Node.new())
    node
  end

  def pretty_print(node = @root, prefix = "", is_left = true)
    if node.right
      pretty_print(node.right, "#{prefix}#{is_left ? "│   " : "    "}", false)
    end
    puts "#{prefix}#{is_left ? "└── " : "┌── "}#{node.data}"
    if node.left
      pretty_print(node.left, "#{prefix}#{is_left ? "    " : "│   "}", true)
    end
  end

  def insert(node = self.root, value)
    return true if node.data == value
    if node.data > value
      if node.left
        return insert(node.left, value)
      else
        node.left = Node.new(value)
        return true
      end
    elsif node.data < value
      if node.right
        return insert(node.right, value)
      else
        node.right = Node.new(value)
        return true
      end
    end
  end

  def delete(node = self.root, value)
    return node if node.nil?

    if node.data > value
      node.left = delete(node.left, value)
    elsif node.data < value
      node.right = delete(node.right, value)
    else
      return node.right if node.left.nil?
      return node.left if node.right.nil?
      lefty = node.right
      lefty = lefty.left until lefty.left.nil?
      node.data = lefty.data
      node.right = delete(node.right, lefty.data)
    end
    node
  end

  def find(node = self.root, value)
    return node if node.data == value
    if node.data > value
      return find(node.left, value)
    elsif node.data < value
      return find(node.right, value)
    else
      return nil
    end
  end

  def level_order(node = self.root)
    return if node.nil?
    output = []
    que = []
    que.push(node)
    until que.empty?
      cur = que.shift
      output.push(block_given? ? yield(cur) : cur.data)
      que.push(cur.left) if cur.left
      que.push(cur.right) if cur.right
    end
    output
  end

  def in_order(node = self.root, output = [], &block)
    return if node.nil?
    in_order(node.left, output, &block)
    output.push(block_given? ? yield(node) : node.data)
    in_order(node.right, output, &block)
    output
  end

  def pre_order(node = self.root, output = [], &block)
    return if node.nil?
    output.push(block_given? ? yield(node) : node.data)
    pre_order(node.left, output, &block)
    pre_order(node.right, output, &block)
    output
  end

  def post_order(node = self.root, output = [], &block)
    return if node.nil?
    post_order(node.left, output, &block)
    post_order(node.right, output, &block)
    output.push(block_given? ? yield(node) : node.data)
    output
  end

  def height(node = self.root)
    return 0 if node.left.nil? and node.right.nil?
    if node.left.nil?
      return 1 + height(node.right)
    elsif node.right.nil?
      return 1 + height(node.left)
    else
      return 1 + [height(node.left), height(node.right)].max
    end
  end

  def depth(parent = self.root, node)
    return 0 if parent.data == node
    return -1 if parent.nil?

    if node > parent.data
      return 1 + depth(parent.right, node)
    elsif node < parent.data
      return 1 + depth(parent.left, node)
    end
  end

  def balanced?(node = self.root)
    return true if (height(node.left) - height(node.right)).abs <= 0
    false
  end

  def rebalance()
    array = in_order()
    build_tree(array)
  end
end

tree = Tree.new()
ar = (Array.new(15) { rand(1..100) })
tree.build_tree(ar)
tree.pretty_print
p tree.balanced?
p tree.level_order
p tree.pre_order
p tree.post_order
p tree.in_order
tree.insert(rand(101..200))
tree.insert(rand(101..200))
tree.insert(rand(101..200))
tree.pretty_print
p tree.balanced?
tree.rebalance
tree.pretty_print
p tree.balanced?
p tree.level_order
p tree.pre_order
p tree.post_order
p tree.in_order

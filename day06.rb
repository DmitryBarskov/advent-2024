require 'set'

def find_position(map, target)
  map.each_with_index do |row, i|
    row.each_with_index do |cell, j|
      return [i, j] if cell == target
    end
  end
end

def trace(map, start)
  position = start
  direction = :up
  path = Set.new
  visited = {}

  loop do
    return [:out, path] unless in_range?(map, position)
    return [:loop, path] if visited[position]&.include?(direction)

    path.add(position)
    visited[position] ||= Set.new
    visited[position].add(direction)

    cell_in_front = move(position, direction)
    next_direction =
      if map.dig(*cell_in_front) == "#"
        rotate(direction)
      else
        direction
      end

    next_position = move(position, next_direction)
    visited[position].add(next_direction)

    position, direction = [next_position, next_direction]
  end
end

def in_range?(map, position)
  y, x = position
  (0...map.size).include?(y) && (0...map[y].size).include?(x)
end

def move(position, direction)
  y, x = position
  case direction
  when :up then [y - 1, x]
  when :down then [y + 1, x]
  when :left then [y, x - 1]
  when :right then [y, x + 1]
  else raise ArgumentError
  end
end

def rotate(direction)
  { up: :right, right: :down, down: :left, left: :up }[direction]
end

def main
  map = ARGF.readlines.map(&:chomp).map(&:chars)

  start = find_position(map, "^")
  p start

  _result, path = trace(map, start)
  p path.size
end

main

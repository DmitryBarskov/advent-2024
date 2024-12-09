def main
  input = ARGF.readlines.first.chomp.chars.map(&:to_i)
  disk = input.zip([:file, :free].cycle).map { |size, type| { size: size, type: type } }
  enumerate_files!(disk)
  compact!(disk)
  p checksum(disk)
end

def enumerate_files!(disk)
  id = 0
  disk.each do |block|
    next if block[:type] == :free

    block[:id] = id
    id += 1
  end
end

def compact!(disk)
  j = disk.size - 1
  while j > 0
    next j -= 1 if disk[j][:type] == :free

    free_space = disk.find_index { |block| block[:type] == :free && block[:size] >= disk[j][:size] }
    next j -= 1 if free_space.nil? || free_space >= j

    file_block = disk[j]
    disk[j] = { type: :free, size: file_block[:size] }
    if file_block[:size] == disk[free_space][:size]
      disk[free_space] = file_block
      j -= 1
    else
      disk[free_space][:size] -= file_block[:size]
      disk.insert(free_space, file_block)
    end
  end

  disk
end

def checksum(disk)
  sum = 0
  position = 0
  disk.each do |block|
    case block[:type]
    when :free
      position += block[:size]
    when :file
      block[:size].times do
        sum += block[:id] * position
        position += 1
      end
    end
  end
  sum
end

def inspect_disk(disk)
  str = []
  disk.each do |block|
    block[:size].times do
      case block[:type]
      when :free
        str.push('.')
      when :file
        str.push(block[:id])
      end
    end
  end
  str.join
end

main

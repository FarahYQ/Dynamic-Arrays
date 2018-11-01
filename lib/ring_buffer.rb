require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    @capacity = 8
    @store = StaticArray.new(@capacity)
    @length = 0
    @start_idx = 0
  end

  # O(1)
  def [](index)
    raise "index out of bounds" unless check_index(index)
    @store[(@start_idx + index) % @capacity]
  end

  # O(1)
  def []=(index, val)
    raise "index out of bounds" unless check_index(index)
    @store[(@start_idx + index) % @capacity] = val
  end

  # O(1)
  def pop
    # raise "index out of bounds" if @length == 0
    # popped = @store[(@start_idx + @length-1) % @capacity]
    # @length -= 1
    # popped
    raise 'index out of bounds' if @length == 0
    @length -= 1
    @store[(@start_idx + @length) % @capacity]
  end

  # O(1) ammortized
  def push(val)
    # if @length + 1 > @capacity
    #   self.resize!
    # end
    # @store[(@start_idx + @length) % @capacity] = val
    # @length += 1

    resize! if @length == @capacity
    @store[(@start_idx + @length) % @capacity] = val
    @length += 1

  end

  # O(1)
  def shift
    # raise "index out of bounds" if @length == 0
    # shifted = @store[@start_idx]
    # @store[@start_idx] = nil
    # @length -= 1
    # @start_idx += 1
    # shifted
    raise 'index out of bounds' if @length == 0
    shifted = self[0]
    @length -= 1
    @start_idx += 1
    shifted
  end

  # O(1) ammortized
  def unshift(val)
    # if @length == @capacity
    #   self.resize!
    # end
    # self[@start_idx-1] = val
    # @start_idx -= 1
    # @length += 1
    resize! if @length == @capacity
    @start_idx -= 1
    @length += 1
    self[0] = val

  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
    index <= @capacity && index < @length
  end

  def resize!
    new_arr = StaticArray.new(2 * @capacity)

    @length.times do |idx|
      new_arr[(start_idx + idx) % @length] = @store[idx]

    end
    @capacity = 2 * @capacity
    @store = new_arr
    @start_idx = 0
  end
end

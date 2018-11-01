require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    @capacity = 8
    @store = StaticArray.new(@capacity)
    @length = 0
    # @start_idx = 0
  end

  # O(1)
  def [](index)
    raise "index out of bounds" if @length <= index
    @store[index]
  end

  # O(1)
  def []=(index, value)
    raise "index out of bounds" if @length <= index
    @store[index] = value
  end

  # O(1)
  def pop
    # raise "index out of bounds" if @length == 0
    # popped = self[@length-1]
    # self[@length-1] = nil
    # @length -= 1
    # popped
    val, store[length - 1] = store[length -1], nil
    self.length -= 1 
    val
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    if @length == @capacity
      self.resize!
    end
    @store[@length] = val
    @length += 1
  end

  # O(n): has to shift over all the elements.
  def shift
    raise "index out of bounds" if @length == 0
    shifted = @store[0]
    @store = @store[1..-1]
    @length -= 1
    shifted
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    # if @start_idx == 0
    #   (@length-1).downto(0) do |i|
    #     @store[i+1] = @store[i]
    #   end
    #   @store[0] = val
    # else 
    #   @store[@start_idx - 1] = val
    #   @start_idx -= 1
    #   @length += 1
    # end
    if @length == @capacity
      self.resize!
    end
    (@length-1).downto(0) do |i|
      @store[i+1] = @store[i]
    end
    @store[0] = val
    @length += 1
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
    index >= 0 && index < length
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    temp = @store
    @store = Array.new(@capacity*2)
    @length.times do |i|
      @store[i] = temp[i]
    end
    @capacity *= 2
  end
end

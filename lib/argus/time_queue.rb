class TimeQueue
  Item = Struct.new(:time, :value) do
    def <=>(other)
      time <=> other.time
    end

    def key
      object_id
    end

    def to_s(basetime=nil)
      if basetime
        "#{value.inspect}@+#{time-basetime}"
      else
        "#{value.inspect}@#{time.strftime('%H:%M:%S.%L')}"
      end
    end
  end

  def initialize
    @items = []
  end

  def add(time, value)
    item = Item.new(time, value)
    @items << item
    @items.sort!
    item.key
  end

  def remove(key)
    @items.delete_if { |item| item.key == key }
  end

  def any_ready?(time)
    ! @items.empty? && @items.first.time <= time
  end

  def all_ready(time)
    result = []
    each_ready(time) do |value| result << value end
    result
  end

  def each_ready(time)
    while any_ready?(time)
      item = @items.shift
      yield item.value
    end
  end

  def to_s
    base_time = nil
    strings = @items[0,3].map { |item|
      string = item.to_s(base_time)
      base_time ||= item.time
      string
    }
    strings << "..." if @items.size > 3
    "[#{strings.join(', ')}]"
  end
end

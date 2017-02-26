# :nodoc:
class Grid
  attr_accessor :rows, :columns, :matrix

  def initialize(*args)
    case args.size
    when 2
      raise ArgumentError, 'Argument type(s) is not Integer' unless args.each { |arg| arg.is_a? Integer }
      @rows = args[0].to_i
      @columns = args[1].to_i
      @matrix = init_matrix(@rows, @columns, 0)
    when 3
      @rows = args[0].to_i
      @columns = args[1].to_i
      val = args[2].to_a
      @matrix = matrix_wrapper(val, 1)[0]
    else
      raise ArgumentError, 'Argument number (#{args.size}) is wrong'
    end
  end

  def init_matrix(m_rows, m_columns, val)
    matrix = Array.new(m_rows) { Array.new(m_columns) }
    matrix[0..m_rows - 1].each { |row| fill_array(row, val) }
  end

  def matrix_wrapper(from_array, times)
    wrapper = []
    array = Array.new(1) { Array.new(from_array) }
    times.times { wrapper.concat(array) }
    wrapper
  end

  def set_value(row, col, val)
    raise ArgumentError, 'Argument type(s) is not Integer' unless (row.is_a? Integer) || (row.is_a? Integer) || (val.is_a? Integer)
    raise ArgumentError, 'Argument(s) (: 1, 2) cannot be negative Integer(s)' unless row >= 0 || col >= 0
    @matrix[row][col] = val
  end

  def get_value(row, col)
    raise ArgumentError, 'Argument type(s) is not Integer' unless (row.is_a? Integer) || (row.is_a? Integer)
    raise ArgumentError, 'Argument(s) (: 1, 2, 3) cannot be negative Integer(s)' unless row >= 0 || col >= 0
    @matrix[row][col]
  end

  def fill_array(array, val)
    array.map! { val }
  end

  #
  # @overload add_row(n_times, from_row)
  #   @param [Integer] n_times How many rows to add.
  #   @param [Integer] from_row Index to start expansion from.
  #   @return [Array<Integer>, Array[Integer]] Grid with added n_times row(s) *after* from_row and filled with 0s.
  #
  # @overload add_row(n_times, from_row, init_val)
  #   @param [Integer] n_times How many rows to add.
  #   @param [Integer] from_row Index to start expansion from.
  #   @param [Integer] init_val Init value (Integer).
  #   @return [Array<Integer>, Array[Integer]] Grid with added n_times row(s) *after* from_row and filled with init_val.
  #
  # @overload add_row(n_times, from_row, src_array)
  #   @param [Integer] n_times How many rows to add.
  #   @param [Integer] from_row Index to start expansion from.
  #   @param [Array<Integer>] src_array Injecting array of Integers.
  #   @return [Array<Integer>, Array[Integer]] Grid with added n_times src_array(s) *after* from_row.
  #
  # @overload add_row(n_times, from_row, init_val, direction)
  #   @param [Integer] n_times How many rows to add.
  #   @param [Integer] from_row Index to start expansion from.
  #   @param [Integer] init_val Init value (Integer).
  #   @param [Integer] direction 0: right, -1: left.
  #   @return [Array<Integer>, Array[Integer]] Grid with added n_times row(s) from_row, filled with init_val,
  #   after or before the from_row index, according to the value of direction (0 for after, -1 for before).
  #
  # @overload add_row(n_times, from_row, src_array, direction)
  #   @param [Integer] n_times How many rows to add.
  #   @param [Integer] from_row Index to start expansion from.
  #   @param [Integer] src_array Injecting array of Integers.
  #   @param [Integer] direction 0: right, -1: left.
  #   @return [Array<Integer>, Array[Integer]] Grid with added n_times src_array(s) from_row,
  #   after or before the from_row index, according to the value of direction (0 for after, -1 for before).
  #
  # @note WARN: When an out-of-range upper index is given, the default behaviour will be to
  #   set the index to the grid upper-one, and proceed from there as expected.
  #   NO exceptions will be raised beecause of this.
  #
  # @raise [ArgumentError] If something is wrong with them.
  #
  def add_row(*args)
    case args.size
    when 2..4
      raise ArgumentError, 'Argument type(s) is not Integer' unless args.each { |a| a.is_a? Integer }
      raise ArgumentError, 'Argument(s) (: 1, 2, 3) cannot be negative Integer(s)' unless args.each_with_index { |arg, i| arg.class != Array && (arg >= 0 && i < 3) }
      raise ArgumentError, 'Argument (: direction) shall be in range [-1,0]' unless args.size < 4 || (args.size == 4 && args[3].to_i.between?(-1, 0))

      n_times = args[0].to_i
      from_row = args[1].to_i

      value =
        if args.size == 2
          0
        else
          args[2].is_a?(Array) ? args[2].to_a : args[2].to_i
        end

      direction = args.size < 4 ? 0 : args[3].to_i

      from_row = from_row < @rows - 1 ? from_row : @rows - 1 # ensure upper limit if out-of-range

      injecting_array = value.class == Array ? matrix_wrapper(value, n_times) : init_matrix(n_times, @columns, value)

      index = direction.zero? ? from_row + 1 : from_row

      injecting_array.each do |element|
        @matrix.insert(index, element)
        index += 1
      end

      @rows += n_times
      @matrix
    else
      raise ArgumentError, 'Argument number (#{args.size}) is wrong'
    end
  end

  #
  # @overload delete_row(n_times, from_row)
  #   @param [Integer] n_times How many rows to remove.
  #   @param [Integer] from_column Index to start collapsing from.
  #   @return [Array<Integer>, Array[Integer]] Grid with removed n_times row(s) from_row (included) on (forward).
  #
  # @overload delete_row(n_times, from_row, direction)
  #   @param [Integer] n_times How many rows to remove.
  #   @param [Integer] from_column Index to start collapsing from.
  #   @param [Integer] direction (optional) 0: right, -1: left.
  #   @return [Array<Integer>, Array[Integer]] Grid with removed n_times row(s) from_row (included),
  #   forward if position is set to 0, backward if set to -1.
  #
  # @note WARN: When an out-of-range upper index is given, the default behaviour will be to
  #   simply return the original grid without any modification.
  # @note WARN: By default this function will try to process as many n_times possible,
  #   that is, if n_times exceeds the room available, it will set n_times to the max room.
  #   If there is no room, it will return the grid untouched.
  #
  # @raise [ArgumentError] if something is wrong with them.
  #
  def delete_row(*args)
    case args.size
    when 2..3
      count = args.first.to_i
      position = args[1].to_i
      direction = args.size == 2 ? 0 : args[2].to_i

      # enough room there?
      room = @rows - position

      count = count > room ? room : count
      count =
        if direction.zero?
          room > 0 ? count : 0
        elsif direction == -1
          room < 0 ? 0 : count
        end

      offset = 0
      count.times do
        @matrix.delete_at(position - offset)
        offset += 1 if direction == -1 && position - offset >= 0
      end

      @rows -= count
      @matrix
    else
      raise ArgumentError, 'Argument type(s) is not Integer' unless args.each { |arg| arg.is_a? Integer }
    end
  end

  #
  # @overload add_column(n_times, from_column)
  #   @param [Integer] n_times How many columns to add.
  #   @param [Integer] from_column Index to start expansion from.
  #   @return [Array<Integer>, Array[Integer]] Grid with added n_times col(s) *after* from_column and filled with 0s.
  #
  # @overload add_column(n_times, from_column, init_val)
  #   @param [Integer] n_times How many columns to add.
  #   @param [Integer] from_column Index to start expansion from.
  #   @param [Integer] init_val Init value (Integer).
  #   @return [Array<Integer>, Array[Integer]] Grid with added n_times col(s) *after* from_column and filled with init_val.
  #
  # @overload add_column(n_times, from_column, src_array)
  #   @param [Integer] n_times How many columns to add.
  #   @param [Integer] from_column Index to start expansion from.
  #   @param [Array<Integer>] src_array Injecting array of Integers.
  #   @return [Array<Integer>, Array[Integer]] Grid with added n_times src_array(s) *after* from_column.
  #
  # @overload add_column(n_times, from_column, init_val, direction)
  #   @param [Integer] n_times How many columns to add.
  #   @param [Integer] from_column Index to start expansion from.
  #   @param [Integer] init_val Init value (Integer).
  #   @param [Integer] direction 0: right, -1: left.
  #   @return [Array<Integer>, Array[Integer]] Grid with added n_times col(s) from_column, filled with init_val,
  #   after or before the from_column index, according to the value of direction (0 for after, -1 for before).
  #
  # @overload add_column(n_times, from_column, src_array, direction)
  #   @param [Integer] n_times How many columns to add.
  #   @param [Integer] from_row Index to start expansion from.
  #   @param [Integer] src_array Injecting array of Integers.
  #   @param [Integer] direction 0: right, -1: left.
  #   @return [Array<Integer>, Array[Integer]] Grid with added n_times src_array(s) from_column,
  #   after or before the from_column index, according to the value of direction (0 for after, -1 for before).
  #
  # @note WARN: When an out-of-range upper index is given, the default behaviour will be to
  #   set the index to the grid upper-one, and proceed from there.
  #   NO exceptions will be raised because of this.
  #
  # @raise [ArgumentError] If something is wrong with them.
  #
  def add_column(*args)
    case args.size
    when 2..4
      raise ArgumentError, 'Argument type(s) is not Integer' unless args.each { |arg| arg.is_a? Integer }
      raise ArgumentError, 'Argument(s) (: 1, 2, 3) cannot be negative Integer(s)' unless args.each_with_index { |arg, i| arg.class != Array && (arg >= 0 && i < 3) }
      raise ArgumentError, 'Argument (: position) shall be in range [-1,0]' unless args.size < 4 || (args.size == 4 && args[3].to_i.between?(-1, 0))

      count = args[0].to_i
      position = args[1].to_i

      value =
        if args.size == 2
          0
        else
          args[2].class == Array ? args[2].to_a : args[2].to_i
        end

      direction = args.size == 3 ? 0 : args[3].to_i
      offset = direction == -1 ? 0 : 1
      position = position < @columns - 1 ? position : @columns - 1 # ensure upper limit if out-of-range

      count.times do
        j = 0
        @matrix.each do |row|
          next unless j < @rows
          injecting_value = value.class == Array ? value[j] : value
          row.insert(position + offset, injecting_value)
          j += 1
        end
      end

      @columns += count
      @matrix
    else
      raise ArgumentError, 'Argument number (#{args.size}) is wrong'
    end
  end

  #
  # @overload delete_column(n_times, from_column)
  #   @param [Integer] n_times How many columns to remove.
  #   @param [Integer] from_column Index to start collapsing from.
  #   @return [Array<Integer>, Array[Integer]] Grid with removed n_times col(s) *after* from_column.
  #
  # @overload delete_column(n_times, from_column, direction)
  #   @param [Integer] n_times How many columns to remove.
  #   @param [Integer] from_column Index to start collapsing from.
  #   @param [Integer] direction (optional) 0: right, -1: left.
  #   @return [Array<Integer>, Array[Integer]] Grid with removed n_times col(s) from_column,
  #   after or before the from_column index, according to the value of direction (0 for after, -1 for before).
  #
  # @note WARN: When an out-of-range upper index is given, the default behaviour will be to
  #   simply return the original grid without any modification.
  # @note WARN: By default this function will try to process as many n_times possible,
  #   that is, if n_times exceeds the room available, it will will set n_times to the max room.
  #   If there is no room, it will return the grid untouched.
  #
  # @raise [ArgumentError] if something is wrong with them.
  #
  def delete_column(*args)
    case args.size
    when 2..3
      raise ArgumentError, 'Argument type(s) is not Integer' unless args.each { |arg| arg.is_a? Integer }
      raise ArgumentError, 'Argument(s) (: 1, 2) cannot be negative Integer(s)' unless args.each_with_index { |arg, i| arg >= 0 && i < 2 }
      raise ArgumentError, 'Argument (: position) shall be in range [-1,0]' unless args.size < 3 || (args.size == 3 && args[2].to_i.between?(-1, 0))
      count = args.first.to_i
      position = args[1].to_i
      side = args.size == 2 ? 0 : args[2].to_i

      # enough room there?
      room = @columns - position

      count = count > room ? room : count

      if side.zero?
        count = room > 0 ? count : 0
      elsif side == -1
        count = room < 0 ? 0 : count
      end

      @matrix.each do |row|
        i = 0
        count.times do
          row.delete_at(position - i)
          i += 1 if side == -1 && position - 1 >= 0 # ensure lower boundary is safe
        end
      end

      @columns -= count
      @matrix
    else
      raise ArgumentError, 'Argument type(s) is not Integer' unless args.each { |a| a.is_a? Integer }
    end
  end

  def pick_row(index)
    raise ArgumentError, 'Argument (: index) is out of range' unless index < @rows
    @matrix[index]
  end

  def pick_column(index)
    raise ArgumentError, 'Argument (: index) is out of range' unless index < @columns
    @matrix.map { |row| row[index] }
  end

  # WARN: Injections will consider the passed index as the very first position to inject,
  # while using add_row or add_column you will always access the position after or before the given index.
  #
  # Consequence: use inject_row / inject_col when you need to start overwriting a precise index,
  # use add_row / add_column when you need to perform generic additions right after / before an index.
  #
  # You have been warned.

  # WARN: when using inject_*, you are forced to indicate a direction (0: right, -1: left)

  def inject_row(n_times, from_row, src_array, direction)
    case direction
    when 0
      add_row(1, from_row, src_array, -1)
      add_row(n_times - 1, from_row, src_array, 0) unless n_times > 1
    when -1
      add_row(1, from_row, src_array, 0)
      add_row(n_times - 1, from_row, src_array, -1) unless n_times > 1
    else
      raise ArgumentError, 'Argument number (#{args.size}) is wrong'
    end
  end

  def inject_column(n_times, from_column, src_array, direction)
    case direction
    when 0
      add_column(1, from_column, src_array, -1)
      add_column(n_times - 1, from_column, src_array, 0) unless n_times > 1
    when -1
      add_column(1, from_column, src_array, 0)
      add_column(n_times - 1, from_column, src_array, -1) unless n_times > 1
    else
      raise ArgumentError, 'Argument number (#{args.size}) is wrong'
    end
  end

  def swap_rows(idx_a, idx_b)
    row_a = pick_row(idx_a)
    row_b = pick_row(idx_b)

    delete_row(1, idx_a)
    add_row(1, idx_a, row_b, -1)

    delete_row(1, idx_b)
    add_row(1, idx_b, row_a, -1)
  end

  def swap_columns(idx_a, idx_b)
    column_a = pick_column(idx_a)
    column_b = pick_column(idx_b)

    delete_column(1, idx_a)
    add_column(1, idx_a, column_b, -1)

    delete_column(1, idx_b)
    add_column(1, idx_b, column_a, -1)
  end
end

module Matrix
  module_function

  def new(size)
    Array.new(size) { Array.new(size, 0) }
  end

  def row(matrix, index)
    matrix[index]
  end

  def sum_values_row(matrix, index)
    row(matrix, index).reduce(:+)
  end

  def add_value(matrix, i, j, value)
    matrix[i-1][j-1] += 0.5**value
  end
end

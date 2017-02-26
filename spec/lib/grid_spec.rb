require_relative '../../lib/grid'

describe Grid do
  before do
    @rows = 3
    @columns = 4
    @grid = Grid.new(@rows, @columns)
  end

  it 'is instance-able' do
    expect(@grid).to be_an_instance_of(Grid)
  end

  it 'allows all fields to be access-able' do
    @grid.rows = 5
    @grid.columns = 3
    @grid.matrix = [[1, 0]]

    aggregate_failures do
      expect(@grid.rows).to eql 5
      expect(@grid.columns).to eql 3
      expect(@grid.matrix).to eql [[1, 0]]
    end
  end

  it 'can init a void matrix with zeros and of rows,columns size' do
    expect(@grid.matrix).to eql(
      [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0]
      ]
    )
  end

  it 'can init a void matrix too' do
    @rows = 0
    @columns = 0
    @grid = Grid.new(@rows, @columns)

    expect(@grid.matrix).to eql([])
  end

  it 'can init a matrix from another' do
    @rows = 2
    @columns = 2
    another_matrix = [
      [0, 1],
      [2, 3]
    ]
    @grid = Grid.new(@rows, @columns, another_matrix)

    expect(@grid.matrix).to eql(another_matrix)
  end

  describe '#fill_array' do
    it 'fills the matrix with some given value' do
      expect(@grid.fill_array([0, 0, 0], 1)).to eql([1, 1, 1])
    end
  end

  describe '#set_value' do
    it 'allows to set a given value (Integer) at given coords rows,columns' do
      @grid.set_value(1, 2, 9)

      expect(@grid.matrix).to eql(
        [
          [0, 0, 0, 0],
          [0, 0, 9, 0],
          [0, 0, 0, 0]
        ]
      )
    end
  end

  describe '#get_value' do
    it 'returns value at given coords rows,columns' do
      @grid.set_value(1, 2, 9)

      expect(@grid.get_value(1, 2)).to eql 9
    end
  end

  describe '#init_matrix' do
    it 'inits the matrix correctely with given start value' do
      aggregate_failures do
        expect(@grid.init_matrix(0, 0, 0)).to eql([])
        expect(@grid.init_matrix(1, 0, 0)).to eql([[]])
        expect(@grid.init_matrix(0, 1, 0)).to eql([])
        expect(@grid.init_matrix(1, 1, 0)).to eql([[0]])
        expect(@grid.init_matrix(1, 2, 0)).to eql([[0, 0]])
        expect(@grid.init_matrix(2, 0, 0)).to eql([[], []])
        expect(@grid.init_matrix(2, 1, 0)).to eql([[0], [0]])
        expect(@grid.init_matrix(2, 2, 0)).to eql([[0, 0], [0, 0]])
        expect(@grid.init_matrix(3, 2, 9)).to eql([[9, 9], [9, 9], [9, 9]])
      end
    end
  end

  describe 'manipulation' do
    before do
      @grid.rows = 2
      @grid.columns = 2
      @grid.matrix = [
        [1, 2],
        [3, 4]
      ]
    end

    describe '#add_row' do
      it 'can add 1 row after index 0' do
        aggregate_failures do
          expect(@grid.add_row(1, 0, 0)).to eql(
            [
              [1, 2],
              [0, 0],
              [3, 4]
            ]
          )
          expect(@grid.add_row(1, 0, 7, 0)).to eql(
            [
              [1, 2],
              [7, 7],
              [0, 0],
              [3, 4]
            ]
          )
        end
      end

      it 'can add 1 row before index 0' do
        expect(@grid.add_row(1, 0, 0, -1)).to eql(
          [
            [0, 0],
            [1, 2],
            [3, 4]
          ]
        )
      end

      it 'can add 2 rows after index 0' do
        aggregate_failures do
          expect(@grid.add_row(2, 0, 0)).to eql(
            [
              [1, 2],
              [0, 0],
              [0, 0],
              [3, 4]
            ]
          )
          expect(@grid.add_row(2, 0, 7, 0)).to eql(
            [
              [1, 2],
              [7, 7],
              [7, 7],
              [0, 0],
              [0, 0],
              [3, 4]
            ]
          )
        end
      end

      it 'can add 2 rows before index 0' do
        expect(@grid.add_row(2, 0, 0, -1)).to eql(
          [
            [0, 0],
            [0, 0],
            [1, 2],
            [3, 4]
          ]
        )
      end

      it 'can add 1 row after index 1' do
        aggregate_failures do
          expect(@grid.add_row(1, 1, 0)).to eql(
            [
              [1, 2],
              [3, 4],
              [0, 0]
            ]
          )
          expect(@grid.add_row(1, 1, 7, 0)).to eql(
            [
              [1, 2],
              [3, 4],
              [7, 7],
              [0, 0]
            ]
          )
        end
      end

      it 'can add 1 row before index 1' do
        expect(@grid.add_row(1, 1, 0, -1)).to eql(
          [
            [1, 2],
            [0, 0],
            [3, 4]
          ]
        )
      end

      it 'can add 3 rows after index 1' do
        expect(@grid.add_row(3, 1, 0)).to eql(
          [
            [1, 2],
            [3, 4],
            [0, 0],
            [0, 0],
            [0, 0]
          ]
        )
        expect(@grid.add_row(3, 1, 7, 0)).to eql(
          [
            [1, 2],
            [3, 4],
            [7, 7],
            [7, 7],
            [7, 7],
            [0, 0],
            [0, 0],
            [0, 0]
          ]
        )
      end

      it 'can add 3 rows before index 1' do
        expect(@grid.add_row(3, 1, 0, -1)).to eql(
          [
            [1, 2],
            [0, 0],
            [0, 0],
            [0, 0],
            [3, 4]
          ]
        )
      end

      it 'can add 3 rows after index 2 (out-of-range)' do
        aggregate_failures do
          expect(@grid.add_row(3, 2, 0)).to eql(
            [
              [1, 2],
              [3, 4],
              [0, 0],
              [0, 0],
              [0, 0]
            ]
          )
          expect(@grid.add_row(3, 2, 7, 0)).to eql(
            [
              [1, 2],
              [3, 4],
              [0, 0],
              [7, 7],
              [7, 7],
              [7, 7],
              [0, 0],
              [0, 0]
            ]
          )
        end
      end

      it 'can add 3 rows before index 2 (out-of-range)' do
        expect(@grid.add_row(3, 2, 0, -1)).to eql(
          [
            [1, 2],
            [0, 0],
            [0, 0],
            [0, 0],
            [3, 4]
          ]
        )
      end

      it 'can add no rows at all (you never know..)' do
        expect(@grid.add_row(0, 200_000, 0, -1)).to eql(
          [
            [1, 2],
            [3, 4]
          ]
        )
      end

      it 'should preserve @grid modifications throu several states' do
        aggregate_failures do
          expect(@grid.add_row(1, 0)).to eql(
            [
              [1, 2],
              [0, 0],
              [3, 4]
            ]
          )
          expect(@grid.add_row(1, 1, 1)).to eql(
            [
              [1, 2],
              [0, 0],
              [1, 1],
              [3, 4]
            ]
          )
          expect(@grid.add_row(1, 1, 2, 0)).to eql(
            [
              [1, 2],
              [0, 0],
              [2, 2],
              [1, 1],
              [3, 4]
            ]
          )
          expect(@grid.add_row(2, 100_000, 3, 0)).to eql(
            [
              [1, 2],
              [0, 0],
              [2, 2],
              [1, 1],
              [3, 4],
              [3, 3],
              [3, 3]
            ]
          )
          expect(@grid.add_row(3, 100_000, 4, -1)).to eql(
            [
              [1, 2],
              [0, 0],
              [2, 2],
              [1, 1],
              [3, 4],
              [3, 3],
              [4, 4],
              [4, 4],
              [4, 4],
              [3, 3]
            ]
          )
          expect(@grid.add_row(0, 0)).to eql(
            [
              [1, 2],
              [0, 0],
              [2, 2],
              [1, 1],
              [3, 4],
              [3, 3],
              [4, 4],
              [4, 4],
              [4, 4],
              [3, 3]
            ]
          )
          expect(@grid.add_row(0, 10_000)).to eql(
            [
              [1, 2],
              [0, 0],
              [2, 2],
              [1, 1],
              [3, 4],
              [3, 3],
              [4, 4],
              [4, 4],
              [4, 4],
              [3, 3]
            ]
          )
          expect(@grid.add_row(0, 100_000, 0)).to eql(
            [
              [1, 2],
              [0, 0],
              [2, 2],
              [1, 1],
              [3, 4],
              [3, 3],
              [4, 4],
              [4, 4],
              [4, 4],
              [3, 3]
            ]
          )
          expect(@grid.add_row(0, 100_000, 0, 0)).to eql(
            [
              [1, 2],
              [0, 0],
              [2, 2],
              [1, 1],
              [3, 4],
              [3, 3],
              [4, 4],
              [4, 4],
              [4, 4],
              [3, 3]
            ]
          )
          expect(@grid.add_row(0, 100_000, 0, -1)).to eql(
            [
              [1, 2],
              [0, 0],
              [2, 2],
              [1, 1],
              [3, 4],
              [3, 3],
              [4, 4],
              [4, 4],
              [4, 4],
              [3, 3]
            ]
          )
        end
      end
    end

    describe '#add_column' do
      it 'can add 1 column to the right of index 0' do
        expect(@grid.add_column(1, 0, 0)).to eql(
          [
            [1, 0, 2],
            [3, 0, 4]
          ]
        )
      end

      it 'can add 3 columns to the left of index 1' do
        expect(@grid.add_column(3, 1, 0, -1)).to eql(
          [
            [1, 0, 0, 0, 2],
            [3, 0, 0, 0, 4]
          ]
        )
      end
    end

    it 'should add arrays if given in input in place of an init_value (size does not matter)' do
      injecting_array = [
        [8],
        [6, 6, 6],
        [6, 9],
        [7, 7, 7, 7]
      ]

      aggregate_failures do
        expect(@grid.add_row(1, 1, injecting_array[0])).to eql(
          [
            [1, 2],
            [3, 4],
            [8]
          ]
        )
        expect(@grid.add_row(1, 1, injecting_array[1])).to eql(
          [
            [1, 2],
            [3, 4],
            [6, 6, 6],
            [8]
          ]
        )
        expect(@grid.add_row(2, 0, injecting_array[2], -1)).to eql(
          [
            [6, 9],
            [6, 9],
            [1, 2],
            [3, 4],
            [6, 6, 6],
            [8]
          ]
        )
        expect(@grid.add_row(0, 1, injecting_array[2], -1)).to eql(
          [
            [6, 9],
            [6, 9],
            [1, 2],
            [3, 4],
            [6, 6, 6],
            [8]
          ]
        )
      end
    end

    describe '#delete_row' do
      it 'can delete 1 row to the right of index 0 (included - so, just the index!)' do
        aggregate_failures do
          expect(@grid.delete_row(1, 0)).to eql([[3, 4]])
          expect(@grid.delete_row(1, 0, 0)).to eql([])
        end
      end

      it 'can delete 1 row to the left of index 0 (included - so, just the index!)' do
        expect(@grid.delete_row(1, 0, -1)).to eql([[3, 4]])
      end

      it 'can delete 2 rows to the right of index 0 (included)' do
        expect(@grid.delete_row(2, 0)).to eql([])
      end

      it 'can delete 2 rows to the left of index 0 (included) [WARN: look at notes in doc]' do
        expect(@grid.delete_row(2, 0, -1)).to eql([]) # eats it all
      end
    end
  end

  describe '#add_column' do
    it 'adds n columns from given position' do
      @grid.rows = 2
      @grid.columns = 2
      @grid.matrix = [
        [0, 0],
        [1, 5]
      ]

      expect(@grid.add_column(0, 0)).to eql(
        [
          [0, 0],
          [1, 5]
        ]
      )
      expect(@grid.add_column(1, 0, 0, -1)).to eql(
        [
          [0, 0, 0],
          [0, 1, 5]
        ]
      )
      expect(@grid.add_column(1, 1, 0, -1)).to eql(
        [
          [0, 0, 0, 0],
          [0, 0, 1, 5]
        ]
      )
      expect(@grid.add_column(2, 1, 9, -1)).to eql(
        [
          [0, 9, 9, 0, 0, 0],
          [0, 9, 9, 0, 1, 5]
        ]
      )
      expect(@grid.add_column(2, 5, 3, 0)).to eql(
        [
          [0, 9, 9, 0, 0, 0, 3, 3],
          [0, 9, 9, 0, 1, 5, 3, 3]
        ]
      )
      expect(@grid.add_column(1, 6)).to eql(
        [
          [0, 9, 9, 0, 0, 0, 3, 0, 3],
          [0, 9, 9, 0, 1, 5, 3, 0, 3]
        ]
      )
      expect(@grid.add_column(2, 6, -1)).to eql(
        [
          [0, 9, 9, 0, 0, 0, 3, -1, -1, 0, 3],
          [0, 9, 9, 0, 1, 5, 3, -1, -1, 0, 3]
        ]
      )
      expect(@grid.add_column(1, 100)).to eql(
        [
          [0, 9, 9, 0, 0, 0, 3, -1, -1, 0, 3, 0],
          [0, 9, 9, 0, 1, 5, 3, -1, -1, 0, 3, 0]
        ]
      )
    end

    it 'deletes n columns from given position' do
      @grid.rows = 2
      @grid.columns = 12
      @grid.matrix = [
        [0, 9, 9, 0, 0, 0, 3, -1, -1, 0, 3, 0],
        [0, 9, 9, 0, 1, 5, 3, -1, -1, 0, 3, 0]
      ]

      expect(@grid.delete_column(1, 100)).to eql(
        [
          [0, 9, 9, 0, 0, 0, 3, -1, -1, 0, 3, 0],
          [0, 9, 9, 0, 1, 5, 3, -1, -1, 0, 3, 0]
        ]
      )
      expect(@grid.delete_column(1, 1)).to eql(
        [
          [0, 9, 0, 0, 0, 3, -1, -1, 0, 3, 0],
          [0, 9, 0, 1, 5, 3, -1, -1, 0, 3, 0]
        ]
      )
      expect(@grid.delete_column(100, 1)).to eql([[0], [0]])

      @grid.columns = 10
      @grid.matrix = [
        [0, 9, 0, 0, 0, 3, -1, -1, 0, 3],
        [0, 9, 0, 1, 5, 3, -1, -1, 0, 3]
      ]

      expect(@grid.delete_column(2, 1)).to eql(
        [
          [0, 0, 0, 3, -1, -1, 0, 3],
          [0, 1, 5, 3, -1, -1, 0, 3]
        ]
      )
      expect(@grid.delete_column(2, 1, -1)).to eql(
        [
          [0, 3, -1, -1, 0, 3],
          [5, 3, -1, -1, 0, 3]
        ]
      )
      expect(@grid.delete_column(3, 3, -1)).to eql(
        [
          [0, 0, 3],
          [5, 0, 3]
        ]
      )
      expect(@grid.delete_column(100, 2, -1)).to eql(
        [
          [0, 0],
          [5, 0]
        ]
      )
    end
  end

  describe 'injection' do
    before do
      @grid.rows = 2
      @grid.columns = 2
      @grid.matrix = [
        [1, 2],
        [3, 4]
      ]
    end

    it 'just works, ok?' do
      injecting_matrix = [
        [6, 6],
        [9, 9, 8]
      ]

      expect(@grid.inject_row(1, 0, injecting_matrix[0], 0)).to eql(
        [
          [6, 6],
          [1, 2],
          [3, 4]
        ]
      )
      expect(@grid.inject_column(1, 0, injecting_matrix[1], 0)).to eql(
        [
          [9, 6, 6],
          [9, 1, 2],
          [8, 3, 4]
        ]
      )
    end
  end

  describe '#pick_row' do
    before do
      @grid.rows = 2
      @grid.columns = 2
      @grid.matrix = [
        [1, 2],
        [3, 4]
      ]
    end

    it 'picks a row by index' do
      expect(@grid.pick_row(0)).to eql([1, 2])
    end
    it 'raises exception if index is wrong' do
      expect { @grid.pick_row(10) }.to raise_error(ArgumentError)
    end
  end

  describe '#pick_column' do
    before do
      @grid.rows = 2
      @grid.columns = 2
      @grid.matrix = [
        [1, 2],
        [3, 4]
      ]
    end

    it 'picks a columns by index' do
      expect(@grid.pick_column(0)).to eql([1, 3])
    end
    it 'raises exception if index is wrong' do
      expect { @grid.pick_column(10) }.to raise_error(ArgumentError)
    end
  end

  describe 'swapping' do
    before do
      @grid.rows = 3
      @grid.columns = 3
      @grid.matrix = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ]
    end

    it 'swaps 2 rows' do
      expect(@grid.swap_rows(0, 1)).to eql(
        [
          [4, 5, 6],
          [1, 2, 3],
          [7, 8, 9]
        ]
      )
    end

    it 'swaps 2 columns' do
      expect(@grid.swap_columns(0, 1)).to eql(
        [
          [2, 1, 3],
          [5, 4, 6],
          [8, 7, 9]
        ]
      )
    end
  end
end

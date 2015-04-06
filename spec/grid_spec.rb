require_relative '../grid'

describe Grid do
  before(:each) do
    @x = 3
    @y = 4
    @g = Grid.new(@x, @y)
  end
  it 'should be instance-able' do
    expect(@g).to be_an_instance_of Grid
  end
  it 'should allow all fields to be access-able' do
    @g.rows = 5
    @g.cols = 3
    @g.grid = [[1, 0]]
    expect(@g.rows).to eql 5
    expect(@g.cols).to eql 3
    expect(@g.grid).to eql [[1, 0]]
  end
  it 'should init a void matrix with zeros and of x,y size' do
    expect(@g.grid).to eql [[0, 0, 0, 0],
                            [0, 0, 0, 0],
                            [0, 0, 0, 0]]
  end
  it 'should init a void matrix too' do
    @x = 0
    @y = 0
    @g = Grid.new(@x, @y)
    expect(@g.grid).to eql []
  end
  it 'should init a matrix from another' do
    @x = 2
    @y = 2
    test = [[0,1],[2, 3]]
    @g = Grid.new(@x, @y, test)
    expect(@g.grid).to eql test
  end
  it 'should allow given arrays (row or col) to be filled with some given value' do
    expect(@g.fill_array([0, 0, 0], 1)).to eql [1, 1, 1]
  end
  it 'should allow to set a given value (Integer) at given coord x,y' do
    @g.set_value(1, 2, 9)
    expect(@g.grid).to eql [[0, 0, 0, 0],
                            [0, 0, 9, 0],
                            [0, 0, 0, 0]]
  end
  it 'should return value at given coord x,y' do
    @g.set_value(1, 2, 9)
    expect(@g.get_value(1, 2)).to eql 9
  end
  describe 'operations on matrices' do
    it 'should allocate correctely with given start value' do
      expect(@g.init_matrix(0, 0, 0)).to eql []
      expect(@g.init_matrix(1, 0, 0)).to eql [[]]
      expect(@g.init_matrix(0, 1, 0)).to eql []
      expect(@g.init_matrix(1, 1, 0)).to eql [[0]]
      expect(@g.init_matrix(1, 2, 0)).to eql [[0, 0]]
      expect(@g.init_matrix(2, 0, 0)).to eql [[], []]
      expect(@g.init_matrix(2, 1, 0)).to eql [[0], [0]]
      expect(@g.init_matrix(2, 2, 0)).to eql [[0, 0],
                                              [0, 0]]
      expect(@g.init_matrix(3, 2, 9)).to eql [[9, 9],
                                              [9, 9],
                                              [9, 9]]
    end
  end
  describe 'manipulation' do
    before :each do
      @g.rows = 2
      @g.cols = 2
      @g.grid = [[1, 2],
                 [3, 4]]
    end
    describe 'should add n rows at given position (after/before)' do
      it 'can add 1 row  to the right of index 0' do
        expect(@g.add_row(1, 0, 0)).to eql [[1, 2], [0, 0], [3, 4]]
        expect(@g.add_row(1, 0, 7, 0)).to eql [[1, 2], [7, 7], [0, 0], [3, 4]]
      end
      it 'can add 1 row  to the left  of index 0' do
        expect(@g.add_row(1, 0, 0, -1)).to eql [[0, 0], [1, 2], [3, 4]]
      end
      it 'can add 2 rows to the right of index 0' do
        expect(@g.add_row(2, 0, 0)).to eql [[1, 2], [0, 0], [0, 0], [3, 4]]
        expect(@g.add_row(2, 0, 7, 0)).to eql [[1, 2], [7, 7], [7, 7], [0, 0], [0, 0], [3, 4]]
      end
      it 'can add 2 rows to the left  of index 0' do
        expect(@g.add_row(2, 0, 0, -1)).to eql [[0, 0], [0, 0], [1, 2], [3, 4]]
      end
      it 'can add 1 row  to the right of index 1' do
        expect(@g.add_row(1, 1, 0)).to eql [[1, 2], [3, 4], [0, 0]]
        expect(@g.add_row(1, 1, 7, 0)).to eql [[1, 2], [3, 4], [7, 7], [0, 0]]
      end
      it 'can add 1 row  to the left  of index 1' do
        expect(@g.add_row(1, 1, 0, -1)).to eql [[1, 2], [0, 0], [3, 4]]
      end
      it 'can add 3 rows to the right of index 1' do
        expect(@g.add_row(3, 1, 0)).to eql [[1, 2], [3, 4], [0, 0], [0, 0], [0, 0]]
        expect(@g.add_row(3, 1, 7, 0)).to eql [[1, 2], [3, 4], [7, 7], [7, 7], [7, 7], [0, 0], [0, 0], [0, 0]]
      end
      it 'can add 3 rows to the left  of index 1' do
        expect(@g.add_row(3, 1, 0, -1)).to eql [[1, 2], [0, 0], [0, 0], [0, 0], [3, 4]]
      end
      it 'can add 3 rows to the right of index 2 (out-of-range)' do
        expect(@g.add_row(3, 2, 0)).to eql [[1, 2], [3, 4], [0, 0], [0, 0], [0, 0]]
        expect(@g.add_row(3, 2, 7, 0)).to eql [[1, 2], [3, 4], [0, 0], [7, 7], [7, 7], [7, 7], [0, 0], [0, 0]]
      end
      it 'can add 3 rows to the left  of index 2 (out-of-range) [WARN: look at notes in doc]' do
        expect(@g.add_row(3, 2, 0, -1)).to eql [[1, 2], [0, 0], [0, 0], [0, 0], [3, 4]]
      end
      it 'can add no rows at all (you never know..)' do
        expect(@g.add_row(0, 200000, 0, -1)).to eql [[1, 2], [3, 4]]
      end
      it 'should preserve @grid modifications throu several states' do
        expect(@g.add_row(1, 0)).to eql [[1, 2], [0, 0], [3, 4]]
        expect(@g.add_row(1, 1, 1)).to eql [[1, 2], [0, 0], [1, 1], [3, 4]]
        expect(@g.add_row(1, 1, 2, 0)).to eql [[1, 2], [0, 0], [2, 2], [1, 1], [3, 4]]
        expect(@g.add_row(2, 100000, 3, 0)).to eql [[1, 2], [0, 0], [2, 2], [1, 1], [3, 4], [3, 3], [3, 3]]
        expect(@g.add_row(3, 100000, 4, -1)).to eql [[1, 2], [0, 0], [2, 2], [1, 1], [3, 4], [3, 3], [4, 4], [4, 4], [4, 4], [3, 3]]
        expect(@g.add_row(0, 0)).to eql [[1, 2], [0, 0], [2, 2], [1, 1], [3, 4], [3, 3], [4, 4], [4, 4], [4, 4], [3, 3]]
        expect(@g.add_row(0, 100000)).to eql [[1, 2], [0, 0], [2, 2], [1, 1], [3, 4], [3, 3], [4, 4], [4, 4], [4, 4], [3, 3]]
        expect(@g.add_row(0, 100000, 0)).to eql [[1, 2], [0, 0], [2, 2], [1, 1], [3, 4], [3, 3], [4, 4], [4, 4], [4, 4], [3, 3]]
        expect(@g.add_row(0, 100000, 0, 0)).to eql [[1, 2], [0, 0], [2, 2], [1, 1], [3, 4], [3, 3], [4, 4], [4, 4], [4, 4], [3, 3]]
        expect(@g.add_row(0, 100000, 0, -1)).to eql [[1, 2], [0, 0], [2, 2], [1, 1], [3, 4], [3, 3], [4, 4], [4, 4], [4, 4], [3, 3]]
      end

    end
    describe 'should add n cols at given position (after/before)' do
      it 'can add 1 col  to the right of index 0' do
        expect(@g.add_col(1, 0, 0)).to eql [[1, 0, 2], [3, 0, 4]]
      end
      it 'can add 3 cols to the left  of index 1' do
        expect(@g.add_col(3, 1, 0, -1)).to eql [[1, 0, 0, 0, 2], [3, 0, 0, 0, 4]]
      end
    end
    it 'should add arrays if given in input in place of an init_value (size does not matter)' do
      test = [[8], [6, 6, 6], [6, 9], [7, 7, 7, 7]]
      expect(@g.add_row(1, 1, test[0])).to eql [[1, 2], [3, 4], [8]]
      expect(@g.add_row(1, 1, test[1])).to eql [[1, 2], [3, 4], [6, 6, 6], [8]]
      expect(@g.add_row(2, 0, test[2], -1)).to eql [[6, 9], [6, 9], [1, 2], [3, 4], [6, 6, 6], [8]]
      expect(@g.add_row(0, 1, test[2], -1)).to eql [[6, 9], [6, 9], [1, 2], [3, 4], [6, 6, 6], [8]]

    end
    describe 'should delete n rows at given position (after, before)' do
      it 'can delete 1 row  to the right of index 0 (included - so, just the index!)' do
        expect(@g.del_row(1, 0)).to eql [[3, 4]]
        expect(@g.del_row(1, 0, 0)).to eql []
      end
      it 'can delete 1 row  to the left  of index 0 (included - so, just the index!)' do
        expect(@g.del_row(1, 0, -1)).to eql [[3, 4]]
      end
      it 'can delete 2 rows to the right of index 0 (included)' do
        expect(@g.del_row(2, 0)).to eql []
      end
      it 'can delete 2 rows to the left  of index 0 (included) [WARN: look at notes in doc]' do
        expect(@g.del_row(2, 0, -1)).to eql [] # consumes all
      end

    end
    it 'should add n cols from given position' do
      @g.rows = 2
      @g.cols = 2
      @g.grid = [[0, 0],
                 [1, 5]]

      expect(@g.add_col(0, 0)).to eql [[0, 0],[1, 5]]
      expect(@g.add_col(1, 0, 0, -1)).to eql [[0, 0, 0],[0, 1, 5]]
      expect(@g.add_col(1, 1, 0, -1)).to eql [[0, 0, 0, 0], [0, 0, 1, 5]]
      expect(@g.add_col(2, 1, 9, -1)).to eql [[0, 9, 9, 0, 0, 0], [0, 9, 9, 0, 1, 5]]
      expect(@g.add_col(2, 5, 3, 0)).to eql [[0, 9, 9, 0, 0, 0, 3, 3], [0, 9, 9, 0, 1, 5, 3, 3]]
      expect(@g.add_col(1, 6)).to eql [[0, 9, 9, 0, 0, 0, 3, 0, 3], [0, 9, 9, 0, 1, 5, 3, 0, 3]]
      expect(@g.add_col(2, 6, -1)).to eql [[0, 9, 9, 0, 0, 0, 3, -1, -1, 0, 3], [0, 9, 9, 0, 1, 5, 3, -1, -1, 0, 3]]
      expect(@g.add_col(1, 100)).to eql [[0, 9, 9, 0, 0, 0, 3, -1, -1, 0, 3, 0], [0, 9, 9, 0, 1, 5, 3, -1, -1, 0, 3, 0]]          
      
    end
    it 'should delete n cols from given position' do
      @g.rows = 2
      @g.cols = 12
      @g.grid = [[0, 9, 9, 0, 0, 0, 3, -1, -1, 0, 3, 0],
                 [0, 9, 9, 0, 1, 5, 3, -1, -1, 0, 3, 0]]  

      expect(@g.del_col(1, 100)).to eql [[0, 9, 9, 0, 0, 0, 3, -1, -1, 0, 3, 0], [0, 9, 9, 0, 1, 5, 3, -1, -1, 0, 3, 0]] 
      expect(@g.del_col(1, 1)).to eql [[0, 9, 0, 0, 0, 3, -1, -1, 0, 3, 0], [0, 9, 0, 1, 5, 3, -1, -1, 0, 3, 0]]
      expect(@g.del_col(100, 1)).to eql [[0], [0]]

      @g.cols = 10
      @g.grid = [[0, 9, 0, 0, 0, 3, -1, -1, 0, 3],
                 [0, 9, 0, 1, 5, 3, -1, -1, 0, 3]]

      expect(@g.del_col(2, 1)).to eql [[0, 0, 0, 3, -1, -1, 0, 3], [0, 1, 5, 3, -1, -1, 0, 3]]
      expect(@g.del_col(2, 1, -1)).to eql [[0, 3, -1, -1, 0, 3], [5, 3, -1, -1, 0, 3]]
      expect(@g.del_col(3, 3, -1)).to eql [[0, 0, 3],[5, 0, 3]]
      expect(@g.del_col(100, 2, -1)).to eql [[0, 0],[5, 0]]

    end
    it 'injection aliases should work' do
      test = [[6, 6], [9, 9, 8]]
      expect(@g.inject_row(1, 0, test[0], 0)).to eql [[6, 6], [1, 2], [3, 4]]
      expect(@g.inject_col(1, 0, test[1], 0)).to eql [[9, 6, 6], [9, 1, 2], [8, 3, 4]]
    end
  end
  describe 'access' do
    before :each do
      @g.rows = 2
      @g.cols = 2
      @g.grid = [[1, 2],
                 [3, 4]]
    end
    describe 'pick rows' do
      it 'should pick rows by index' do
        expect(@g.pick_row(0)).to eql [1, 2]
      end
      it 'should raise exception if index is wrong' do
        expect { @g.pick_row(10) }.to raise_error(ArgumentError)
      end
    end
    describe 'pick cols' do
      it 'should pick cols by index' do
        expect(@g.pick_col(0)).to eql [1, 3]
      end
      it 'should raise exception if index is wrong' do
        expect { @g.pick_col(10) }.to raise_error(ArgumentError)
      end
    end
  end
  describe 'swapping' do
    before :each do
      @g.rows = 3
      @g.cols = 3
      @g.grid = [[1, 2, 3],
                 [4, 5, 6],
                 [7, 8, 9]]
    end
    it 'should swap 2 rows' do 
      expect(@g.swap_rows(0, 1)).to eql [[4, 5, 6], [1, 2, 3], [7, 8, 9]]  
    end 
    it 'should swap 2 cols' do 
      expect(@g.swap_cols(0, 1)).to eql [[2, 1, 3], [5, 4, 6], [8, 7, 9]]  
    end 
  end
end

# ruby-grid example
#
# descr: random swap rows and cols of a single image
#
require 'chunky_png'
require_relative '../lib/grid'

# open image and set up grid
image = ChunkyPNG::Image.from_file('test.png')
g = Grid.new(image.height, 0)

# fill grid
i = 0; (image.width).times { g.inject_column(1, i, image.column(image.width - 1 - i), 0); i += 1; }

# random swaps
(rand(0..image.height)).times { g.swap_rows(rand(0..g.rows - 1),rand(0..g.rows - 1)) }
#(rand(0..image.width)).times { g.swap_cols(rand(0..g.cols-1),rand(0..g.cols-1)) }

# swap pixels
i = 0; (image.width).times { image.replace_column!(i, g.pick_column(i)); i += 1; }

# saving
out = "../generated/gen_#{Time.now.to_i}.png"
image.save(out)

# ruby-grid example
# 
# descr: random swap rows and cols of a single image
#
require 'chunky_png'
require_relative '../grid'

# open image and set up grid
image = ChunkyPNG::Image.from_file('test.png')
g = Grid.new(image.height, 0)


# fill grid
i = 0; (image.width).times { g.inject_col(1, i, image.column(image.width-1-i), 0); i += 1; }

#g.grid.each {|row| row.each { |p| p ChunkyPNG::Color.to_truecolor_alpha_bytes(p) }}
#p ChunkyPNG::Color.to_truecolor_alpha_bytes(ChunkyPNG::Color.rgba(255, 255, 255, 255))

# random swaps
(rand(0..image.height)).times { g.swap_rows(rand(0..g.rows-1),rand(0..g.rows-1)) }
#(rand(0..image.width)).times { g.swap_cols(rand(0..g.cols-1),rand(0..g.cols-1)) }

# swap pixels
i = 0; (image.width).times { image.replace_column!(i, g.pick_col(i)); i += 1; }

# saving
out = "../generated/gen_#{Time.now.to_i}.png"
image.save(out)



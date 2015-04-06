# ruby-grid example
# 
# descr: random inject cols of two differently edited copies of a single image
#
require 'chunky_png'
require_relative '../grid'

# open image and set up grid
image_0 = ChunkyPNG::Image.from_file('gioconda.png')
image_1 = image_0.flip_horizontally

g_0 = Grid.new(image_0.height, 0)
g_1 = Grid.new(image_1.height, 0)


# fill grid
i = 0; (image_0.width).times { g_0.inject_col(1, i, image_0.column(image_0.width-1-i), 0); i += 1; }
i = 0; (image_1.width).times { g_1.inject_col(1, i, image_1.column(image_1.width-1-i), 0); i += 1; }

# rand col inj
(rand(0..image_0.width)).times { g_0.inject_col(1, rand(0..image_0.width-1), g_1.pick_col(rand(0..image_1.width-1)), rand(-1..0)) }

# swap pixels
i = 0; (image_0.width).times { image_0.replace_column!(i, g_0.pick_col(i)); i += 1; }

# saving
out = "../generated/gen_#{Time.now.to_i}.png"
image_0.save(out)
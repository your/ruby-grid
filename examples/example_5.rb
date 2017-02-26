# ruby-grid example
#
# descr: random swap rows and cols of a single image
#
require 'chunky_png'
require 'mini_magick'
require_relative '../lib/grid'

# open image and set up grid

images = [
  'test.png'
]

tmp_file = "#{Time.now.to_i}-tmp.png"

def to_png(input, output)
  image = MiniMagick::Image.open(input)
  image.path #=> "/var/folders/k7/6zx6dx6x7ys3rv3srh0nyfj00000gn/T/magick20140921-75881-1yho3zc.jpg',"
  # image.resize "100x100"
  # image.rotate "90"
  image.format('png')
  image.write(output)
end

images.each do |image|
  to_png(image, tmp_file)

  image_0 = ChunkyPNG::Image.from_file(tmp_file)
  image_1 = image_0.flip_horizontally

  g_0 = Grid.new(image_0.height, 0)
  g_1 = Grid.new(image_1.height, 0)

  # fill grid
  i = 0; (image_0.width).times { g_0.inject_column(1, i, image_0.column(image_0.width - 1 - i), 0); i += 1; }
  i = 0; (image_1.width).times { g_1.inject_column(1, i, image_1.column(image_1.width - 1 - i), 0); i += 1; }

  # play
  100.times { g_0.inject_column(100, 50, g_1.pick_column(300), 0) }
  100.times { g_0.inject_column(100, 50 - 1, g_1.pick_column(200), -1) }
  i = 0; 100.times { g_0.inject_column(1, 50 + 50 + i, g_1.pick_column(i + 100), 0); i += 1; }
  i = 0; 100.times { g_0.swap_rows(50 + 25 + i, i + 100); i += 1; }

  # swap pixels
  i = 0; (image_0.width).times { image_0.replace_column!(i, g_0.pick_column(i)); i += 1; }

  # saving
  out = "../generated/gen_#{Time.now.to_i}.png"
  image_0.save(out)
end

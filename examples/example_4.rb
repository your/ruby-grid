# ruby-grid example
#
# descr: random swap rows and cols of a single image
#
require 'chunky_png'
require_relative '../lib/grid'

def fibonacci(n)
  return n if (0..1).include?(n)
  fibonacci(n - 1) + fibonacci(n - 2)
end

# open image and set up grid
image = ChunkyPNG::Image.from_file('test.png')
g = Grid.new(image.height, 0)

# fill grid
i = 0; (image.width).times { g.inject_column(1, i, image.column(image.width - 1 - i), 0); i += 1; }

# random swaps

(rand(0..image.height)).times {
  a = rand(0..g.rows - 1)
  s = rand(0..100)
  b = a + s < image.height ? a + s : a - s
  if a + s < image.height
    from = a
    to = a + 1
    s.times {
        g.swap_rows(from, to)
        from += 1
        to += 1
    }
  else
    from = a
    to = a - 1
    s.times {
      g.swap_rows(from, to)
      from -= 1
      to -= 1
    }
  end
}

# swap pixels
i = 0; (image.width).times { image.replace_column!(i, g.pick_column(i)); i += 1; }

# saving
out = "../generated/gen_#{Time.now.to_i}.png"
image.save(out)

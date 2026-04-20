def do_something(text, **kwargs)
  col = kwargs[:col]
  row = kwargs[:row]

  puts text
  puts "at #{row}, #{col}"
end

do_something('Hello World', col: 4, row: 5)

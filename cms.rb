t = Base::Template.from_yaml('content/1-index.yaml')
puts "YAML:"
puts t.to_yaml
# puts "\n\n\n"
# puts "PAGE:"
# puts t.to_page
puts "\n\n\n"
puts "FORM:"
puts t.to_form

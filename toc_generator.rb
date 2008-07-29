#!/usr/bin/env ruby
# author: marko dot haapala at aktagon dot com
# idea taken from here: http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/134005
require "rubygems"
require "redcloth"

def generate_toc (file_name, headreg)
	document = IO.read(file_name)
	toc = "" 
	document.gsub(headreg) do |match|
		number = $1
		name = $2
		header = name.gsub(/\s/,"+")
		toc << '#' * number.to_i + ' "' + name + '":#' + header + "\n"
	end
	RedCloth.new(toc).to_html
end

def manipulate_body(file_name, headreg)
	document = IO.read(file_name)
	document.gsub!(headreg) do |match|
		number = $1
		name = $2
		header = name.gsub(/\s/,"+")
		"\nh" + number + '. <a name="' + header + '">' + name + '</a>'
	end
	RedCloth.new(document).to_html
end

if ARGV[0] == nil 
	puts "Oh no! You didn't give me a filename :(" 
	exit 1
end

file_name = ARGV[0]
headreg = /^\s*h([1-6])\.\s+(.*)/
toc = generate_toc(file_name, headreg)
body = manipulate_body(file_name, headreg)
template = <<-'EOF'
<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">
<html xml:lang=\"en\" lang=\"en\" xmlns=\"http://www.w3.org/1999/xhtml\">
	<head>
		<title>#{file_name}</title>
		<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=ISO-8859-1\">
		<link rel=stylesheet href=\"style.css\" type=\"text/css\">
	</head>
	<body>
		#{toc}
		#{body}
	</body>
</html>
EOF
puts eval("\"" + template + "\"")
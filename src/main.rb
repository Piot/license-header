=begin

MIT License

Copyright (c) 2017 Peter Bjorklund

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

=end

require 'file_fetcher.rb'

project_dir = ARGV[0]
license_filename = ARGV[1]

STDERR.puts "project:#{project_dir} license:#{license_filename}"
license_text = File.read license_filename

new_header = "\n"
fetcher = FileFetcher.new project_dir

files = fetcher.fetch ['.'], ['c', 'm', 'h', 'cpp', 'hpp', 'cs', 'go', 'js', 'rs']

files.each do |file_name|
	STDERR.puts "Replacing: #{file_name}"
	extension = File.extname(file_name)[1..-1]
	contents = File.open(file_name,'r:bom|utf-8', &:read)
	# contents = File.read file_name
	contents = contents.lstrip
	contents = contents.sub("\xEF\xBB\xBF".force_encoding('UTF-8'), "")
	new_contents = contents.sub /\/\*(\*(?!\/)|[^*])*\*\//, ''
	new_contents = new_contents.lstrip
	new_contents = new_contents.force_encoding('UTF-8')
	if extension == 'go' then
		new_contents = "\n" + new_contents
	end
	new_contents = new_header + new_contents
	File.write file_name, new_contents
end

STDERR.puts "Done!"

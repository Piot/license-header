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

def dir_scan(rootdir)
 results = []
 dirnames = []
 Dir.entries(rootdir).each do |entry|
  next if entry == '.'
  next if entry == '..'
  fullpath	= [rootdir, entry].join('/')
  dirnames.push(fullpath) if File.directory?(fullpath)
  results.push(fullpath) if !File.directory?(fullpath)
 end
 dirnames.each do |dirname|
  children = dir_scan(dirname)
  results.concat(children)
 end
 results
end

class FileFetcher
 def initialize(base_dir)
  @base_dir = base_dir
 end

 def internal_fetch(subdir, extensions)
  relative_path = File.join @base_dir, subdir
  files = dir_scan relative_path

  only_files = files.reject do |file_name|
   File.directory? file_name
  end

  only_correct_types = only_files.select do |file_name|
	  extension = File.extname(file_name)[1..-1]
	  extensions.include? extension
  end
  only_correct_types.map do |file_name|
   File.absolute_path file_name
  end
 end

 def fetch(subdirs, extensions)
  subdirs.flat_map do |subdir|
   internal_fetch subdir, extensions
  end
 end
end

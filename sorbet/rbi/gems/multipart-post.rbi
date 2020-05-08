# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strong
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/multipart-post/all/multipart-post.rbi
#
# multipart-post-2.1.1

class CompositeReadIO
  def advance_io; end
  def current_io; end
  def initialize(*ios); end
  def read(length = nil, outbuf = nil); end
  def rewind; end
end
class UploadIO
  def content_type; end
  def initialize(filename_or_io, content_type, filename = nil, opts = nil); end
  def io; end
  def local_path; end
  def method_missing(*args); end
  def opts; end
  def original_filename; end
  def respond_to?(meth, include_all = nil); end
  def self.convert!(io, content_type, original_filename, local_path); end
end
module Parts
end
module Parts::Part
  def length; end
  def self.file?(value); end
  def self.new(boundary, name, value, headers = nil); end
  def to_io; end
end
class Parts::ParamPart
  def build_part(boundary, name, value, headers = nil); end
  def initialize(boundary, name, value, headers = nil); end
  def length; end
  include Parts::Part
end
class Parts::FilePart
  def build_head(boundary, name, filename, type, content_len, opts = nil); end
  def initialize(boundary, name, io, headers = nil); end
  def length; end
  include Parts::Part
end
class Parts::EpiloguePart
  def initialize(boundary); end
  include Parts::Part
end

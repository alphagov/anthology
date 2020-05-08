# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strong
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/execjs/all/execjs.rbi
#
# execjs-2.7.0

module ExecJS
  def self.compile(source, options = nil); end
  def self.cygwin?; end
  def self.eval(source, options = nil); end
  def self.exec(source, options = nil); end
  def self.root; end
  def self.runtime; end
  def self.runtime=(runtime); end
  def self.runtimes; end
  def self.windows?; end
end
class ExecJS::Error < StandardError
end
class ExecJS::RuntimeError < ExecJS::Error
end
class ExecJS::ProgramError < ExecJS::Error
end
class ExecJS::RuntimeUnavailable < ExecJS::RuntimeError
end
module ExecJS::Encoding
  def encode(string); end
end
class ExecJS::Runtime
  def available?; end
  def compile(source, options = nil); end
  def context_class; end
  def deprecated?; end
  def eval(source, options = nil); end
  def exec(source, options = nil); end
  def name; end
end
class ExecJS::Runtime::Context
  def call(properties, *args); end
  def eval(source, options = nil); end
  def exec(source, options = nil); end
  def initialize(runtime, source = nil, options = nil); end
  include ExecJS::Encoding
end
class ExecJS::DisabledRuntime < ExecJS::Runtime
  def available?; end
  def compile(source, options = nil); end
  def deprecated?; end
  def eval(source, options = nil); end
  def exec(source, options = nil); end
  def name; end
end
class ExecJS::DuktapeRuntime < ExecJS::Runtime
  def available?; end
  def name; end
end
class ExecJS::DuktapeRuntime::Context < ExecJS::Runtime::Context
  def call(identifier, *args); end
  def eval(source, options = nil); end
  def exec(source, options = nil); end
  def initialize(runtime, source = nil, options = nil); end
  def wrap_error(e); end
end
class ExecJS::ExternalRuntime < ExecJS::Runtime
  def available?; end
  def binary; end
  def deprecated?; end
  def encode_source(source); end
  def encode_unicode_codepoints(str); end
  def exec_runtime(filename); end
  def exec_runtime_error(output); end
  def generate_compile_method(path); end
  def initialize(options); end
  def json2_source; end
  def locate_executable(command); end
  def name; end
  def which(command); end
end
class ExecJS::ExternalRuntime::Context < ExecJS::Runtime::Context
  def call(identifier, *args); end
  def create_tempfile(basename); end
  def eval(source, options = nil); end
  def exec(source, options = nil); end
  def extract_result(output, filename); end
  def initialize(runtime, source = nil, options = nil); end
  def write_to_tempfile(contents); end
end
class ExecJS::RubyRacerRuntime < ExecJS::Runtime
  def available?; end
  def name; end
end
class ExecJS::RubyRacerRuntime::Context < ExecJS::Runtime::Context
  def call(properties, *args); end
  def eval(source, options = nil); end
  def exec(source, options = nil); end
  def initialize(runtime, source = nil, options = nil); end
  def lock; end
  def unbox(value); end
  def wrap_error(e); end
end
class ExecJS::RubyRhinoRuntime < ExecJS::Runtime
  def available?; end
  def name; end
end
class ExecJS::RubyRhinoRuntime::Context < ExecJS::Runtime::Context
  def call(properties, *args); end
  def eval(source, options = nil); end
  def exec(source, options = nil); end
  def fix_memory_limit!(context); end
  def initialize(runtime, source = nil, options = nil); end
  def unbox(value); end
  def wrap_error(e); end
end
class ExecJS::MiniRacerRuntime < ExecJS::Runtime
  def available?; end
  def name; end
end
class ExecJS::MiniRacerRuntime::Context < ExecJS::Runtime::Context
  def call(identifier, *args); end
  def eval(source, options = nil); end
  def exec(source, options = nil); end
  def initialize(runtime, source = nil, options = nil); end
  def strip_functions!(value); end
  def translate; end
end
module ExecJS::Runtimes
  def self.autodetect; end
  def self.best_available; end
  def self.from_environment; end
  def self.names; end
  def self.runtimes; end
end

# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

if RUBY_ENGINE == "jruby"
  ExecJS.runtime = ExecJS::Runtimes::Node
end

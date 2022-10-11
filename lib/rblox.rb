# frozen_string_literal: true

require "rblox/version"
require "rblox/scanner"
require "rblox/grammar"

module RbLox
  class Interpreter
    def initialize
      @had_error = false
    end

    def read_source_file(file)
      # TODO: error handling
      f_contents = ::File.read(file)
      p f_contents
    end

    def run_prompt
      loop do
        # TODO: how to chomp newline?
        puts "> "
        line = gets
        next if line.strip == ""

        run(line)
        @had_error = false
      end
    end

    def run(line)
      tokens = Scanner.new(line)
      tokens.scantokens.each do |t|
        puts "tok: #{t}"
      end
    end

    def error(line, msg)
      report(line, "", msg)
    end

    def report(line, where, msg)
      puts "[line #{line}] Error #{where}: #{msg}"
    end
  end
end

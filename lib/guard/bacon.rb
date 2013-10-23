# encoding: utf-8

require 'bacon'
require 'guard'
require 'guard/guard'

require File.expand_path('../bacon/version', __FILE__)

module Guard
  class Bacon < Guard

    def initialize(watchers= [], options= {})
      @last_run_spec = nil
      super
    end

    def start
      puts "Guard::Bacon started."
      true
    end

    # Called on Ctrl-C signal (when Guard quits)
    def stop
      true
    end

    # Called on Ctrl-Z signal
    def reload
      true
    end

    # Called on Ctrl-\ signal
    # This method should be principally used for long action like running all specs/tests/...
    def run_all
      Dir["spec/**/*_spec.rb"].each do |path|
        run_spec(path)
      end

      true
    end

    def run_spec(path)
      if !File.exists?(path) && @last_run_spec
        puts "spec not found: #{path}"
        puts "running last one."
        path = @last_run_spec
      end

      if File.exists?(path)
        @last_run_spec = path
        Kernel.system("bundle exec bacon -q #{path}")
      else
        puts "spec not found: #{path}"
      end
    end

    def file_changed(path)
      run_spec(path)
      puts ""
    end

    # Called on file(s) modifications
    def run_on_changes(paths)
      paths.each do |path|
        file_changed(path)
      end
    end

  end
end

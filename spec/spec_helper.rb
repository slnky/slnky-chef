$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'slnky'
require 'slnky/chef'
require 'yaml'
require 'erb'
require 'tilt'

require 'dotenv'
@dotenv = Dotenv.load

def event(name)
  @events ||= {}
  @events[name] ||= begin
    file = File.expand_path("../../test/events/#{name}.json", __FILE__)
    raise "file #{file} not found" unless File.exists?(file)
    Slnky::Data.new(JSON.parse(File.read(file)))
  end
end

def command(name)
  @commands ||= {}
  @commands[name] ||= begin
    file = File.expand_path("../../test/commands/#{name}.json", __FILE__)
    raise "file #{file} not found" unless File.exists?(file)
    Slnky::Command::Request.new(JSON.parse(File.read(file)))
  end
end

def test_config
  @config ||= begin
    file = File.expand_path("../../test/config.yaml", __FILE__)
    template = Tilt::ERBTemplate.new(file)
    output = template.render(self, @dotenv)
    cfg = Slnky::Data.new(YAML.load(output))
    cfg.environment = 'test'
    cfg
  end
end

require 'tty-prompt'

module Menu

  class << self
    attr_accessor :tty_prompt
  end

  def self.prompt
    self.tty_prompt ||= TTY::Prompt.new
  end

end
module Workspace
  class Folder

    def self.recreate(path)
      Helper::Logging.info("Recreating workspace: #{path}...")
      self.delete(path)
      self.create(path)
    end

    def self.create(path)
      unless self.exists?(path)
        Dir.mkdir(path) 
      end
    end

    def self.delete(path)
      FileUtils.rm_rf(path) if self.exists?(path)
    end

    def self.exists?(path)
      Dir.exist?(path)
    end
    
  end
end
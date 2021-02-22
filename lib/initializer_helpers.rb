module InitializerHelpers

    def self.skip_console_rake_generators &block
      skip(defined?(Rails::Console) || defined?(Rails::Generators) || File.basename($0) == "rake", &block)
    end
  
    def self.skip_rake_generators &block
      skip(defined?(Rails::Generators) || File.basename($0) == "rake", &block)
    end
  
    def self.skip_generators &block
      skip(defined?(Rails::Generators), &block)
    end
  
    def self.skip_console &block
      skip(defined?(Rails::Console), &block)
    end
  
    private
  
    def self.skip(condition, &block)
      raise ArgumentError.new("no block given") if block.blank?
      unless condition
        yield
      end
    end
  
  end
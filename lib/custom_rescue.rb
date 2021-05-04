module CustomRescue
    def rescue_exception(with:)
      methods = self.methods(false)
      methods = methods.reject{|m| m == with }
        methods.each do |name|
          method = self.method(name)
          define_singleton_method(name) do |*args|
            begin
             method.call(*args)
            rescue StandardError => e
              rescue_method = self.method(with)
              rescue_method.call(e)
            end
          end
        end
    end

    def rescue_igdb_base
      begin
        yield
      rescue NoMethodError
        $igdb_base = IGDB::Base.new
        yield
      end
    end
end
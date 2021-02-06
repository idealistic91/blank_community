class FutureValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless record[attribute].nil?
        if record[attribute] < Time.now
          record.errors[attribute] << (options[:message] || "can't be in the past!")
        end
      end
    end
end
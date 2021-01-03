class FutureValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if record[attribute] < Time.now
        record.errors[attribute] << (options[:message] || "can't be in the past!")
      end
    end
end
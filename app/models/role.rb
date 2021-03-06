class Role < ApplicationRecord
  STATIC_TYPES = I18n.t('activerecord.models.role.options_static_types')

  def self.register_types_and_methods
    STATIC_TYPES.each do |key, _value|
      unless self.find_by(key: key)
        self.create(key: key.to_s)
      end
      register_methods(key)
    end
  end

  def self.register_methods(key)
    define_method "#{key}?" do
      self.key == key.to_s
    end
    define_method "label" do
      STATIC_TYPES[self.key.to_sym]
    end
    define_singleton_method "#{key}_label" do
      STATIC_TYPES[key.to_sym]
    end
    define_singleton_method "#{key}_role" do
      find_by(key: "#{key}")
    end
  end

  register_types_and_methods
end
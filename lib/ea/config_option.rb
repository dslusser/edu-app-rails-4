module EA
  class ConfigOption
    include Hashable
    attr_accessor :name, :description, :type, :isRequired, :defaultValue

    def initialize(attrs={})
      attrs.each do |key,value|
        instance_variable_set("@#{key}",value)
      end
      @is_required ||= false
    end
  end
end
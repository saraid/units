module Units
  class DerivedUnit < Unit
    def self.for(operator, *operands)
      return operands.first if operands.size == 1
      return operands.first if operator == :** && operands[1] == 1
      @registry ||= {}
      @registry[operator] ||= {}
      @registry[operator][operands] ||= new(operator, operands)
    end

    def initialize(operator, operands)
      @operator = operator
      @operands = operands
    end

    def to_s
      case @operator
      when :* then @operands.map(&:to_s).join('·')
      when :/ then @operands.map(&:to_s).join('/')
      when :** then @operands.map(&:to_s).join('^')
      else raise "Whoops"
      end
    end

    def format(number)
      "#{number} #{to_s}"
    end
  end
end

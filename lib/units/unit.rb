module Units
  class Unit
    def self.instance
      @instance ||= new
    end

    def self.of(type)
      (@types ||= {})[type] ||= Class.new(self) do
        @type = type

        def self.name
          "Unit_of#{@type.to_s.capitalize}"
        end

        def type
          self.class.superclass
        end

        def self.subclasses
          Units.constants.map(&Units.method(:const_get)).select do |const|
            Class === const && const < self
          end
        end
      end.tap do |cls|
        Units.const_set(cls.name.to_sym, cls)
      end
    end

    def inspect
      postamble = " #{to_s.to_sym.inspect}" unless to_s.start_with?(' ')
      "#<#{self.class}:#{'0x%x' % (object_id << 1)}#{postamble}>"
    end

    def format(number)
      case number
      when Rational
        if number.denominator == 1 then number.to_i
        else number
        end
      else number
      end
        .yield_self { |n| [n, to_s] }
        .join
    end

    def conversions
      {}
    end

    def transitive_conversions
      @transitive_conversions ||=
        conversions.keys.each.with_object({}) do |first_degree_converter, transitives|
          first_degree_converter.instance.conversions.keys.each do |second_degree_converter|
            #transitives[second_degree_converter] = conversions[first_degree_converter][:conversion] >> first_degree_converter.instance.conversions[second_degree_converter][:conversion]
            transitives[second_degree_converter] = [
              conversions[first_degree_converter],
              first_degree_converter.instance.conversions[second_degree_converter]
            ]
              .map { |c| c[:conversion] }
              .reduce(:>>)
          end
        end
    end

    def can_convert_to?(unit)
      conversions.key?(unit) || conversions.key?(unit.class)
    end

    def convert(unit)
      raise ArgumentError, 'cannot convert between different types' unless unit.type == type
      return conversions.fetch(unit.class)[:conversion] if conversions.key?(unit.class)

      transitive_conversions.fetch(unit.class)
    end

    def *(unit)
      DerivedUnit.for(:*, self, unit)
    end

    def /(unit)
      DerivedUnit.for(:/, self, unit)
    end
  end
end

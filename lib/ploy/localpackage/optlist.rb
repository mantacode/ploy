module Ploy
  module LocalPackage
    class DebBuilderOptlist
      @list = []
      def initialize(list = [])
        @list = list
      end

      def add(switch, val = nil)
        opt = val != nil ? { switch => val } : switch
        @list.push(opt)
      end

      def as_string
        opts_flat = []

        @list.each do | e |
          if (e.is_a? Hash) then
            e.each { | k, v| opts_flat.push([k,v].join(' ')) }
          else
            opts_flat.push(e)
          end
        end

        return opts_flat.join(' ')
      end

    end
  end
end

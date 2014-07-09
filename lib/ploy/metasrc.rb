module Ploy
  class MetaSrc
    def initialize(dir)
      @dir = dir
    end
    def load
      d = {}
      return {} unless Dir.exists? @dir
      Dir.foreach(@dir) do |fname|
        if (fname =~ /\.ya?ml$/) then
          y = YAML::load_file(File.join(@dir,fname))
          d[y['name']] = y
        end
      end
      return d
    end
  end
end

module Ploy

  # Loads Meta data from YAML files

  class MetaSrc

    # initialize an instance with the directory specified

    def initialize(dir)
      @dir = dir
    end

    # Uses the instance's dir attribute to load the yaml
    # files in that directory.  The yaml data is stored
    # into a hash using the "name" attribute from the yaml
    # document

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

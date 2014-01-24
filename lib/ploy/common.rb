module Ploy
  module Util

    # Builds the path to the remote package

    def Util.remote_name(deploy,branch,rev, variant = nil)
      r = [
        deploy,
        branch,
        "#{deploy}_#{rev}.deb"
      ]
      if (variant) then
        r.unshift(variant)
      end
      return r.join('/')
    end

  end
end

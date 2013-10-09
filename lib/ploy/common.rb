module Ploy
  module Util

    def Util.remote_name(deploy,branch,rev, blessed = false)
      r = [
        deploy,
        branch,
        "#{deploy}_#{rev}.deb"
      ]
      if (blessed) then
        r.unshift('blessed')
      end
      return r.join('/')
    end

  end
end

module Pdns
  module Helpers
    def check_pdns_version(version)
      case version
        when '4.1', '41' then '41'
        else '40'
      end
    end
  end
end
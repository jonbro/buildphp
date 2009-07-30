module Buildphp
  class Mbstring < Package
    def php_config_flags
      [
        # [BUNDLED]
        "--enable-mbstring",
        "--enable-mbregex",
        "--enable-mbregex-backtrack",
        "--with-libmbfl",
      ]
    end
    
    def rake
      task to_sym
    end
  end
end
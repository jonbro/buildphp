module Buildphp
  module Packages
    class Soap < Buildphp::Package
      def package_depends_on
        [
          'xml',
        ]
      end

      def php_config_flags
        [
          "--enable-soap=shared",
        ]
      end

      def rake
        task to_sym => package_depends_on do
          abort "xml must be an included php module to install #{self}" if FACTORY['php'].php_modules.index('xml') == nil
        end
      end
    end
  end
end
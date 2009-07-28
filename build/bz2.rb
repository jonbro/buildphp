class Bz2 < Package
  PACKAGE_VERSION = '1.0.5'
  
  def versions
    {
      '1.0.5' => { :md5 => '3c15a0c8d1d3ee1c46a1634d00617b1a' },
    }
  end
  
  def package_name
    'bzip2-%s.tar.gz' % @version
  end
  
  def package_dir
    'bzip2-%s' % @version
  end
  
  def package_location
    'http://www.bzip.org/%s/%s' % [@version, package_name]
  end
  
  def php_config_flags
    [
      "--with-bz2=shared,#{PACKAGE_PREFIX}",
    ]
  end
  
  def is_installed
    not FileList["#{PACKAGE_PREFIX}/lib/libbz2.*"].empty?
  end
  
  def rake
    namespace to_sym do
      task :get do
        get
      end

      task :compile => ((package_depends_on || []) + [:get]) do
        cmd = "make"
        # bz2 does not detect whether to compile with position-independent code (PIC) or not, so we must decide that.
        # If we detect x86_64-linux as the platform, prepend -fPIC flag to gcc compile options to enable PIC.
        # http://en.wikipedia.org/wiki/Position_independent_code
        # 
        # Ideally, we should detect the platform and use the appropriate PIC flag for that platform.
        # 
        # If we don't do this, while compiling PHP will complain that bz2 was not compiled with PIC.
        if RUBY_PLATFORM.index("x86_64") != nil
          # use GNU sed options because we're on linux
          cmd = "sed -r -i.bak -e 's/^(CFLAGS=)(.+)$/\\1-fPIC \\2/' Makefile && make"
        end
        compile(cmd)
      end

      task :install => :compile do
        install("make install PREFIX=#{PACKAGE_PREFIX}")
      end
    end

    task to_sym => "#{underscored}:install"
  end
end


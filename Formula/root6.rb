class Root6 < Formula
  desc "CERN C++ Data Analysis and Persistency Libraries"
  homepage "http://root.cern.ch"
  url "http://root.cern.ch/download/root_v6.14.04.source.tar.gz"
  mirror "https://fossies.org/linux/misc/root_v6.14.04.source.tar.gz"
  version "6.14.04"
  sha256 "463ec20692332a422cfb5f38c78bedab1c40ab4d81be18e99b50cf9f53f596cf"
  revision 1

  head "http://root.cern.ch/git/root.git"

  depends_on "cmake" => :build
  depends_on "libxml2" unless OS.mac? # For XML on Linux
  depends_on "xz" # For LZMA
  depends_on "openssl"
  depends_on "sqlite"
  depends_on "gsl"
  depends_on "python@2"
  depends_on "tbb"
  depends_on "vdt"
  depends_on "drbenmorgan/homebrew-warwick/xrootd"

  conflicts_with "root", :because => "Warwick requires custom root build"

  needs :cxx11

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    ENV.delete("SDKROOT") if DevelopmentTools.clang_build_version >= 900
    args = *std_cmake_args
    args << "-DCMAKE_INSTALL_ELISPDIR=#{elisp}"

    # Disable everything that might be ON by default
    args += %w[
      -Dalien=OFF
      -Dasimage=OFF
      -Dastiff=OFF
      -Dbonjour=OFF
      -Dcastor=OFF
      -Dchirp=OFF
      -Ddavix=OFF
      -Ddcache=OFF
      -Dfitsio=OFF
      -Dfortran=OFF
      -Dgfal=OFF
      -Dglite=OFF
      -Dgviz=OFF
      -Dhdfs=OFF
      -Dkrb5=OFF
      -Dldap=OFF
      -Dmonalisa=OFF
      -Dmysql=OFF
      -Dodbc=OFF
      -Doracle=OFF
      -Dpgsql=OFF
      -Dpythia6=OFF
      -Dpythia8=OFF
      -Dqt=OFF
      -Drfio=OFF
      -Dsapdb=OFF
      -Dsrp=OFF
      -Dunuran=OFF
    ]

    # Now the core/builtin things we want
    args += %w[
      -Dcxx11=ON
      -Dfail-on-missing=ON
      -Dgnuinstall=ON
      -Dexplicitlink=ON
      -Drpath=ON
      -Dsoversion=ON
      -Dbuiltin_asimage=ON
      -Dasimage=ON
      -Dbuiltin_fftw3=ON
      -Dbuiltin_freetype=ON
      -Droofit=ON
      -Dgdml=ON
      -Dminuit2=ON
    ]

    # Options that require an external
    args += %w[
      -Dsqlite=ON
      -Dssl=ON
      -Dmathmore=ON
      -Dxrootd=ON
    ]

    # Python requires a bit of finessing
    ENV.prepend_path "PATH", Formula["python@2"].opt_libexec/"bin"
    python_executable = Utils.popen_read("which python2").strip
    python_version = Language::Python.major_minor_version("python2")

    python_prefix = Utils.popen_read("#{python_executable} -c 'import sys;print(sys.prefix)'").chomp
    python_include = Utils.popen_read("#{python_executable} -c 'from distutils import sysconfig;print(sysconfig.get_python_inc(True))'").chomp
    args << "-Dpython=ON"

    # cmake picks up the system's python dylib, even if we have a brewed one
    dylib = OS.mac? ? "dylib" : "so"
    if File.exist? "#{python_prefix}/Python"
      python_library = "#{python_prefix}/Python"
    elsif File.exist? "#{python_prefix}/lib/libpython#{python_version}.#{dylib}"
      python_library = "#{python_prefix}/lib/libpython#{python_version}.#{dylib}"
    elsif File.exist? "#{python_prefix}/lib/libpython#{python_version}.a"
      python_library = "#{python_prefix}/lib/libpython#{python_version}.a"
    else
      odie "No libpythonX.Y.{dylib|so,a} file found!"
    end
    args << "-DPYTHON_EXECUTABLE='#{python_executable}'"
    args << "-DPYTHON_INCLUDE_DIR='#{python_include}'"
    args << "-DPYTHON_LIBRARY='#{python_library}'"

    mkdir "cmake-build" do
      system "cmake", "..", *args

      # Follow upstream homebrew
      # Work around superenv stripping out isysroot leading to errors with
      # libsystem_symptoms.dylib (only available on >= 10.12) and
      # libsystem_darwin.dylib (only available on >= 10.13)
      if OS.mac? && MacOS.version < :high_sierra
        system "xcrun", "make", "install"
      else
        system "make", "install"
      end

      chmod 0755, Dir[bin/"*.*sh"]
    end
  end

  def caveats; <<~EOS
    Because ROOT depends on several installation-dependent
    environment variables to function properly, you should
    add the following commands to your shell initialization
    script (.bashrc/.profile/etc.), or call them directly
    before using ROOT.

    For bash users:
      . $(brew --prefix root6)/libexec/thisroot.sh
    For zsh users:
      pushd $(brew --prefix root6) >/dev/null; . libexec/thisroot.sh; popd >/dev/null
    For csh/tcsh users:
      source `brew --prefix root6`/libexec/thisroot.csh
    EOS
  end

  test do
    (testpath/"test.C").write <<~EOS
      #include <iostream>
      void test() {
        std::cout << "Hello, world!" << std::endl;
      }
    EOS
    (testpath/"test.bash").write <<~EOS
      . #{bin}/thisroot.sh
      root -l -b -n -q test.C
    EOS
    assert_equal "\nProcessing test.C...\nHello, world!\n",
                 shell_output("/bin/bash test.bash")

    ENV["PYTHONPATH"] = #{lib}/"root"
    system "python2", "-c", "'import ROOT'"
  end
end

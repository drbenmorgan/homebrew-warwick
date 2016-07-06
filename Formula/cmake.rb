class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://cmake.org/files/v3.5/cmake-3.5.2.tar.gz"
  sha256 "92d8410d3d981bb881dfff2aed466da55a58d34c7390d50449aa59b32bb5e62a"
  revision 1 if OS.linux?

  head "https://cmake.org/cmake.git"

  patch :DATA

  bottle do
    cellar :any_skip_relocation
    sha256 "2366e55b9466d7f8499c21784711e7006ed36258c7ac3b2ad16612d005c56020" => :el_capitan
    sha256 "b6211f8e35ea232c822da67b03fe76892d216c434b43448c958d62905cff5317" => :yosemite
    sha256 "0f1a4cf28813ee8f95f06267902f2d9fb586307cd27d3ffeec22c87525e09c4c" => :mavericks
    sha256 "eb47b9417a394cb7f9f550d00cdb29ef0c3a497f64d8130ec6cfca9bddc653c2" => :x86_64_linux
  end

  option "without-docs", "Don't build man pages"
  option "with-completion", "Install Bash completion (Has potential problems with system bash)"

  depends_on "sphinx-doc" => :build if build.with? "docs"
  depends_on "bzip2" unless OS.mac?
  depends_on "curl" unless OS.mac?
  depends_on "libidn" unless OS.mac?

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use brew install caskroom/cask/cmake.

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV.deparallelize if ENV["CIRCLECI"]

    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
      --system-zlib
      --system-bzip2
    ]

    # https://github.com/Homebrew/homebrew/issues/45989
    if OS.mac? && MacOS.version <= :lion
      args << "--no-system-curl"
    else
      args << "--system-curl"
    end

    if build.with? "docs"
      # There is an existing issue around OS X & Python locale setting
      # See https://bugs.python.org/issue18378#msg215215 for explanation
      ENV["LC_ALL"] = "en_US.UTF-8"
      args << "--sphinx-man" << "--sphinx-build=#{Formula["sphinx-doc"].opt_bin}/sphinx-build"
    end

    system "./bootstrap", *args
    system "make"
    system "make", "install"

    if build.with? "completion"
      cd "Auxiliary/bash-completion/" do
        bash_completion.install "ctest", "cmake", "cpack"
      end
    end

    (share/"emacs/site-lisp/cmake").install "Auxiliary/cmake-mode.el"

    rm_f pkgshare/"Modules/CPack.OSXScriptLauncher.in" unless OS.mac?
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system "#{bin}/cmake", "."
  end
end
__END__
diff --git a/Tests/CMakeLists.txt b/Tests/CMakeLists.txt
index 7bb0721..3b6e79e 100644
--- a/Tests/CMakeLists.txt
+++ b/Tests/CMakeLists.txt
@@ -1399,10 +1399,10 @@ ${CMake_BINARY_DIR}/bin/cmake -DDIR=dev -P ${CMake_SOURCE_DIR}/Utilities/Release
     ADD_TEST_MACRO(FindMatlab.versions_checks   ${CMAKE_CTEST_COMMAND} -C $<CONFIGURATION>)
   endif()
 
-  find_package(GTK2 QUIET)
-  if(GTK2_FOUND)
-    add_subdirectory(FindGTK2)
-  endif()
+  #find_package(GTK2 QUIET)
+  #if(GTK2_FOUND)
+  #  add_subdirectory(FindGTK2)
+  #endif()
 
   add_test(ExternalProject ${CMAKE_CTEST_COMMAND}
     --build-and-test

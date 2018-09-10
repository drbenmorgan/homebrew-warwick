class Vc < Formula
  desc "Portable, zero-overhead C++ types for explicitly data-parallel programming"
  homepage "https://github.com/VcDevel/Vc"
  url "https://github.com/VcDevel/Vc/archive/1.3.3.tar.gz"
  version "1.3.3"
  sha256 "32f1bdd4046a90907a2b63ee39d72ad0e6d0608937f8202d759d7fa0eddd1ec1"

  depends_on "cmake" => :build
  needs :cxx11

  def install
    mkdir 'brew-build' do
      system "cmake", "..", "-DBUILD_TESTING=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test Vc`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end

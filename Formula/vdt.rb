class Vdt < Formula
  desc "A collection of fast/inline/vectorised mathematical functions"
  homepage "https://github.com/dpiparo/vdt"
  url "https://github.com/dpiparo/vdt/archive/v0.4.1.tar.gz"
  sha256 "020ae76518d67476c3cb9a3fdf0683ee982d6b1a5898739000072ce34063072c"

  depends_on "python@2" => :build
  depends_on "cmake" => :build

  needs :cxx11

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    system "false"
  end
end

class Umesimd < Formula
  desc "UME::SIMD A library for explicit simd vectorization"
  homepage "ihttps://github.com/edanor/umesimd"
  url "https://github.com/edanor/umesimd/archive/v0.8.1.tar.gz"
  version "0.8.1"
  sha256 "78f457634ee593495083cf8eb6ec1cf7f274db5ff7210c37b3a954f1a712d357"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    system "false"
  end
end

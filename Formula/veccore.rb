class Veccore < Formula
  desc "SIMD Vectorization Library"
  homepage "https://github.com/root-project/veccore"
  url "https://github.com/root-project/veccore/archive/v0.5.0.tar.gz"
  version "0.5.0"
  sha256 "5b52205c1213574fa43d6362b60b0e16239035cf64106f8841d7beb7e32bdd03"

  depends_on "cmake" => :build

  depends_on "umesimd" => :recommended
  depends_on "vc" => :recommended

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    system "false"
  end
end

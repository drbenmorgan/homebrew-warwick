class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "http://xrootd.org"
  url "http://xrootd.org/download/v4.8.4/xrootd-4.8.4.tar.gz"
  sha256 "f148d55b16525567c0f893edf9bb2975f7c09f87f0599463e19e1b456a9d95ba"
  head "https://github.com/xrootd/xrootd.git"

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "readline"

  needs :cxx11

  def install
    ENV.cxx11
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_INSTALL_LIBDIR=#{lib}", "-DENABLE_FUSE=OFF", "-DENABLE_KRB5=OFF", *std_cmake_args
      system "make", "install"
    end
    share.install prefix/"man" unless OS.linux?
  end

  test do
    system "#{bin}/xrootd", "-H"
  end
end

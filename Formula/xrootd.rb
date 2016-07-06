class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "http://xrootd.org"
  url "http://xrootd.org/download/v4.3.0/xrootd-4.3.0.tar.gz"
  sha256 "d34865772d975b5d58ad80bb05312bf49aaf124d5431e54dc8618c05a0870e3c"
  head "https://github.com/xrootd/xrootd.git"

  depends_on "cmake" => :build
  depends_on "openssl"

  option :cxx11

  def install
    ENV.cxx11 if build.with? "c++11"
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_INSTALL_LIBDIR=#{lib}", *std_cmake_args
      system "make", "install"
    end
    share.install prefix/"man" unless OS.linux?
  end

  test do
    system "#{bin}/xrootd", "-H"
  end
end

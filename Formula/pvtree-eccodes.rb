# Documentation: http://docs.brew.sh/Formula-Cookbook.html
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class PvtreeEccodes < Formula
  desc ""
  homepage ""
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.4.0-Source.tar.gz"
  sha256 "2c360c32c26e858917d332b26de1269bcc39a4a39c882f1b73b4a96633843947"

  keg_only "Only for PVTree project"

  depends_on "cmake" => :build

  needs :cxx11

  def install
    ENV.cxx11
    mkdir "brew-build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install" # if this fails, try separate make/make install steps
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test eccodes`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end

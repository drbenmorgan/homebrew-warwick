# Documentation: https://docs.brew.sh/Formula-Cookbook
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Vecgeom < Formula
  desc "The vectorized geometry library for particle-detector simulation"
  homepage "https://gitlab.cern.ch/VecGeom/VecGeom.git"
  url "https://gitlab.cern.ch/VecGeom/VecGeom/-/archive/v00.05.01/VecGeom-v00.05.01.tar.gz"
  version "0.5.1"
  sha256 ""

  keg_only "VecGeom does not namespace its headers so may clash with other Formulae"

  depends_on "cmake" => :build
  depends_on "veccore"
  # Cannot get tests to pass just yet with this
  #depends_on "vc" => :recommended


  def install
    vecgeom_args = std_cmake_args
    vecgeom_args << "-DVECGEOM_VECTOR=sse2"
    vecgeom_args << "-DBUILTIN_VECCORE=OFF"
    #vecgeom_args << ("-DBACKEND=Vc" if build.with? "vc")
    # This would namespace, but ends up installing into build area...
    #vecgeom_args << "-DINSTALL_INCLUDE_DIR=include/vecgeom"

    system "cmake", ".", *vecgeom_args
    system "make"
    system "ctest"
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test VecGeom`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end

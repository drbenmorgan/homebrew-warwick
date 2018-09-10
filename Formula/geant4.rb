class Geant4 < Formula
  homepage "http://geant4.cern.ch"
  url "http://geant4.cern.ch/support/source/geant4.10.04.p02.tar.gz"
  version "10.04.02"
  sha256 "2cac09e799f2eb609a7f1e4082d3d9d3d4d9e1930a8c4f9ecdad72aad35cdf10"

  depends_on "cmake" => :build
  depends_on "zlib"
  depends_on "expat"
  depends_on "xerces-c"
  depends_on "drbenmorgan/warwick/clhep"
  depends_on "drbenmorgan/warwick/qt5-base"
  needs :cxx11

  def install
    mkdir 'geant4-build' do
      ENV.cxx11
      args = std_cmake_args
      args << "-DCMAKE_INSTALL_LIBDIR=lib"
      args << "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"
      args << "-DGEANT4_BUILD_MULTITHREADED=ON"
      args << "-DGEANT4_BUILD_CXXSTD=c++11"
      args << "-DGEANT4_USE_SYSTEM_CLHEP=ON"
      args << "-DGEANT4_USE_SYSTEM_ZLIB=ON"
      args << "-DGEANT4_USE_SYSTEM_EXPAT=ON"
      args << "-DGEANT4_USE_GDML=ON"
      args << "-DGEANT4_USE_RAYTRACER_X11=ON"
      args << "-DGEANT4_USE_OPENGL_X11=ON"
      args << "-DGEANT4_USE_QT=ON"
      # Default to installing data "in place" for now
      args << "-DGEANT4_INSTALL_DATA=ON"

      system "cmake", "../", *args
      system "make", "install" # if this fails, try separate make/make install steps
    end
  end

  test do
    system "false"
  end
end


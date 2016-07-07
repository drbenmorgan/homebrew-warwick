class Geant4 < Formula
  homepage "http://geant4.cern.ch"
  url "http://geant4.cern.ch/support/source/geant4.10.02.p02.tar.gz"
  version "10.02.02"
  sha256 "702fb0f7a78d4bdf1e3f14508de26e4db5e2df6a21a8066a92b7e6ce21f4eb2d"

  patch :DATA

  depends_on "cmake" => :build
  #depends_on :x11

  needs :cxx11
  option 'with-gdml', "Build with GDML support"

  depends_on 'drbenmorgan/warwick/clhep' => 'c++11'
  depends_on 'drbenmorgan/warwick/xerces-c' => 'c++11' if build.with? 'gdml'

  def install
    mkdir 'geant4-build' do
      ENV.cxx11
      args = std_cmake_args
      args << "-DCMAKE_INSTALL_LIBDIR=lib"
      args << "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"
      args << "-DGEANT4_BUILD_MULTITHREADED=ON"
      args << "-DGEANT4_BUILD_CXXSTD=c++11" if build.cxx11?
      args << "-DGEANT4_USE_SYSTEM_CLHEP=ON"
      args << "-DGEANT4_USE_SYSTEM_ZLIB=ON"
      args << "-DGEANT4_USE_RAYTRACER_X11=ON"
      args << "-DGEANT4_USE_OPENGL_X11=ON"

      args << "-DGEANT4_USE_GDML=ON" if build.with? "gdml"

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

__END__
diff --git a/cmake/Modules/Geant4ConfigureConfigScript.cmake b/cmake/Modules/Geant4ConfigureConfigScript.cmake
index 2a7a4cc..79a327e 100644
--- a/cmake/Modules/Geant4ConfigureConfigScript.cmake
+++ b/cmake/Modules/Geant4ConfigureConfigScript.cmake
@@ -117,7 +117,9 @@ if(NOT GEANT4_BUILD_GRANULAR_LIBS AND UNIX)
     set(G4_BUILTWITH_GDML "yes")
     set(G4_XERCESC_INCLUDE_DIRS ${XERCESC_INCLUDE_DIRS})
     list(REMOVE_DUPLICATES G4_XERCESC_INCLUDE_DIRS)
-    list(REMOVE_ITEM G4_XERCESC_INCLUDE_DIRS ${_cxx_compiler_dirs})
+    if(_cxx_compiler_dirs)
+      list(REMOVE_ITEM G4_XERCESC_INCLUDE_DIRS ${_cxx_compiler_dirs})
+    endif()
 
     set(G4_XERCESC_CFLAGS )
     foreach(_dir ${G4_XERCESC_INCLUDE_DIRS})
@@ -157,7 +159,9 @@ if(NOT GEANT4_BUILD_GRANULAR_LIBS AND UNIX)
     endif()
 
     list(REMOVE_DUPLICATES G4_QT_INCLUDE_DIRS)
-    list(REMOVE_ITEM G4_QT_INCLUDE_DIRS ${_cxx_compiler_dirs})
+    if(_cxx_compiler_dirs)
+      list(REMOVE_ITEM G4_QT_INCLUDE_DIRS ${_cxx_compiler_dirs})
+    endif()
 
     set(G4_QT_CFLAGS )
     foreach(_dir ${G4_QT_INCLUDE_DIRS})
@@ -218,7 +222,9 @@ if(NOT GEANT4_BUILD_GRANULAR_LIBS AND UNIX)
   if(G4_CONFIG_NEEDS_X11)
     set(_raw_x11_includes ${X11_INCLUDE_DIR})
     list(REMOVE_DUPLICATES _raw_x11_includes)
-    list(REMOVE_ITEM _raw_x11_includes ${_cxx_compiler_dirs})
+    if(_cxx_compiler_dirs)
+      list(REMOVE_ITEM _raw_x11_includes ${_cxx_compiler_dirs})
+    endif()
     set(G4_X11_CFLAGS )
     foreach(_p ${_raw_x11_includes})
       set(G4_X11_CFLAGS "-I${_p} ${G4_X11_CFLAGS}")


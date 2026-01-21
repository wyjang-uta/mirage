#----------------------------------------------------------------------------
# Setup the project
#
cmake_minimum_required(VERSION 3.16...3.27)
project(dipole_defocus)

# settings for dunegpvm spack environment
set(EXPAT_INCLUDE_DIR "/usr/include")
set(EXPAT_LIBRARY "/usr/lib64/libexpat.so")

#----------------------------------------------------------------------------
# Find Geant4 package, activating all available UI and Vis drivers by default
# See the documentation for a guide on how to enable/disable specific components
#
find_package(Geant4 REQUIRED ui_all vis_all)

#----------------------------------------------------------------------------
# Locate sources and headers for this project
# NB: headers are included so they will show up in IDEs
#
file(GLOB sources ${PROJECT_SOURCE_DIR}/src/*.cc)
file(GLOB headers ${PROJECT_SOURCE_DIR}/include/*.hh)

#----------------------------------------------------------------------------
# Add the executable, use our local headers, and link it to the Geant4 libraries
#
add_executable(dipole_defocus dipole_defocus.cc ${sources} ${headers})
target_include_directories(dipole_defocus PRIVATE include)
target_link_libraries(dipole_defocus PRIVATE ${Geant4_LIBRARIES})

#----------------------------------------------------------------------------
# Copy all scripts to the build directory, i.e. the directory in which we
# build dipole_defocus. This is so that we can run the executable directly because it
# relies on these scripts being in the current working directory.
#
set(DIPOLE_DEFOCUS_MACROS
  macros/init_vis.mac
  macros/run1.mac
  macros/run2.mac
  macros/vis.mac
  )

set(DIPOLE_DEFOCUS_SCRIPTS
  scripts/agent.sh
  scripts/submit_grid.sh
  )

foreach(_script ${DIPOLE_DEFOCUS_SCRIPTS})
  configure_file(
    ${PROJECT_SOURCE_DIR}/${_script}
    ${PROJECT_BINARY_DIR}/${_script}
    COPYONLY
    )
endforeach()

foreach(_macro ${DIPOLE_DEFOCUS_MACROS})
  configure_file(
    ${PROJECT_SOURCE_DIR}/${_macro}
    ${PROJECT_BINARY_DIR}/${_macro}
    COPYONLY
  )
endforeach()

# 1. configure install path
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "/exp/dune/app/users/wyjang" CACHE PATH "..." FORCE)
endif()
set(SHARE_DIR "share/dune_mixedpol/dipole")

# 2. installation of binary files
install(TARGETS dipole_defocus DESTINATION bin)

# 3. installation of macro files
install(FILES ${DIPOLE_DEFOCUS_MACROS}
  DESTINATION ${SHARE_DIR}/macros)

# 4. installation of script files
install(FILES ${DIPOLE_DEFOCUS_SCRIPTS}
  DESTINATION ${SHARE_DIR}/scripts
  PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
  )
# Get the path to the overseer pro install
get_filename_component(OP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(OP_ROOTDIR ${OP_ROOTDIR} ABSOLUTE)

# Remove any old cached data
unset(Zookeeper_INCLUDE_DIR CACHE)
unset(Zookeeper_LIBRARY_DIRS CACHE)
unset(Zookeeper_LIB CACHE)

# Set the include and libs paths
set(Zookeeper_INCLUDE_DIR ${OP_ROOTDIR}/include/)
set(Zookeeper_LIBS_DIR ${OP_ROOTDIR}/lib)
include_directories(SYSTEM ${Zookeeper_INCLUDE_DIR}/zookeeper)

# Windows needs the .lib and the winsock library
if(WIN32)
  if(CMAKE_BUILD_TYPE MATCHES DEBUG)
    set(Zookeeper_LIB ${Zookeeper_LIBS_DIR}/libzookeeperd-mt.lib)
  else()
    set(Zookeeper_LIB ${Zookeeper_LIBS_DIR}/libzookeeper-mt.lib)
  endif()
  list(APPEND Zookeeper_LIB ws2_32.lib)
else()
  # Unix just needs the .a
  set(Zookeeper_LIB ${Zookeeper_LIBS_DIR}/libzookeeper-mt.a)
endif()


# Add the zookeeper headers to the system includes
include_directories(SYSTEM ${Zookeeper_INCLUDE_DIR})

# Add zookeeper to the target
# @param[in] target The target to add zookeeper to
# @param[in,opt] define whether to link the library as static
macro(opAddZookeeperToTarget target static)
  if(${static})
    add_definitions(-DUSE_STATIC_LIB)
  endif()

  target_link_libraries(${target} PUBLIC ${Zookeeper_LIB})
endmacro()

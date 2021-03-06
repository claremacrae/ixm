include_guard(GLOBAL)

# TODO: This is being removed...
import(IXM::Target::*)

# TODO: Remove from IXM
# Common arguments:
# ALIAS <name>
# COMPONENT <name>
# ALL (flag)
function (target subcommand)
  if (subcommand STREQUAL "SOURCES")
    ixm_target_sources(${ARGN})
  else()
    log(FATAL "target(${subcommand}) is not a valid subcommand")
  endif()
endfunction ()

# Like target_link_libraries, but copies all custom IXM properties
function(target_copy_properties target)
  get_property(interface-properties GLOBAL PROPERTY IXM_INTERFACE_PROPERTIES)
  get_property(private-properties GLOBAL PROPERTY IXM_PRIVATE_PROPERTIES)

  parse(${ARGN} @ARGS=* PRIVATE PUBLIC INTERFACE)

  # TODO: make target verification occur *outside* of copy loops
  foreach (tgt IN LISTS PRIVATE PUBLIC)
    if (NOT TARGET ${tgt})
      log(FATAL "'${tgt}' is not a known target")
    endif()
    foreach (property IN LISTS private-properties)
      get_target_property(value ${tgt} ${property})
      if (NOT value)
        continue()
      endif()
      set_property(TARGET ${target} APPEND PROPERTY ${property} ${value})
    endforeach()
  endforeach()
endfunction()

include_guard(GLOBAL)

function (cmake::package variable access value current stack)
  if (NOT variable STREQUAL "CMAKE_FIND_PACKAGE_NAME")
    log(FATAL "cmake::package may only be used on CMAKE_FIND_PACKAGE_NAME")
  endif()
  if (access STREQUAL "MODIFIED_ACCESS")
    ixm_find_package_constructor(${value})
    get_property(events GLOBAL PROPERTY ixm::events::find-package::begin)
  elseif (access STREQUAL "REMOVED_ACCESS")
    ixm_find_package_destructor()
    get_property(name GLOBAL PROPERTY ixm::find)
    string(TOUPPER ${name} upper)
    set(${name}_FOUND ${${name}_FOUND} PARENT_SCOPE)
  endif()
endfunction()

# TODO: need to handle a specific case where `enable_testing()` is called in a
# directory that is NOT the root directory. This can be disabled by setting
# `CMAKE_TESTING_ENABLED to OFF
# We can then generate our own RUN_TESTS or `tests` target :D
function (cmake::directory variable access value current stack)
  if (NOT variable STREQUAL "CMAKE_CURRENT_LIST_DIR")
    log(FATAL "cmake::directory may only be used on CMAKE_CURRENT_LIST_DIR")
  endif()
  # TODO: We need to remove the "plugability" of this, as invoke() MUST be
  # removed before the alpha release
  if (access STREQUAL "MODIFIED_ACCESS" AND value)
    get_property(events GLOBAL PROPERTY ixm::events::configure::begin)
    foreach (event IN LISTS events)
      invoke(${event} ${value})
    endforeach()
  elseif (access STREQUAL "MODIFIED_ACCESS" AND value STREQUAL "")
    get_property(events GLOBAL PROPERTY ixm::events::configure::end)
    foreach (event IN LISTS events)
      invoke(${event})
    endforeach()
  endif()
endfunction()

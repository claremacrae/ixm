include_guard(GLOBAL)

function(ixm_cmake_backport_check_progress action)
  if (action STREQUAL "CHECK_START")
    string(JOIN "" message ${ARGN})
    set_property(GLOBAL APPEND PROPERTY cmake::backport::check_in_progress "${message}")
    _message(STATUS "${message}")
    return()
  endif()
  get_property(check_in_progress GLOBAL PROPERTY cmake::backport::check_in_progress)
  if (NOT check_in_progress)
    _message(AUTHOR_WARNING "Ignored ${action} without CHECK_START")
    return()
  endif()
  list(POP_BACK check_in_progress message)
  set_property(GLOBAL PROPERTY cmake::backport::check_in_progress ${check_in_progress})
  _message(STATUS "${message} - " ${ARGN})
endfunction()

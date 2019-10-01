include_guard(GLOBAL)

function (ixm_target_archive name)
  void(ALIAS)
  parse(${ARGN} @ARGS=? ALIAS)
  add_library(${name} STATIC)
  if (ALIAS)
    add_library(${ALIAS} ALIAS ${name})
  endif()
  event(EMIT target:archive ${name})
endfunction()

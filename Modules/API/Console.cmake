include_guard(GLOBAL)

function (console type name)
  void(WITH AS)
  string(ASCII 27 esc)
  if (type STREQUAL "STYLE" AND NOT DEFINED CACHE{.${name}})
    cmake_parse_arguments("" "" "" "WITH" ${ARGN})
    set(.${name} "${esc}[${_WITH}m" CACHE INTERNAL "")
  elseif (type STREQUAL "COLOR" AND NOT DEFINED CACHE{.${name}})
    cmake_parse_arguments("" "" "" "WITH" ${ARGN})
    set(.${name} "${esc}[38;2;${_WITH}m" CACHE INTERNAL "")
  elseif (type STREQUAL "STRIP")
    cmake_parse_arguments("" "" "AS" "" ${ARGN})
    string(REPLACE "${esc}[^m]*m" "" output "${name}")
    set(${_AS} ${output} PARENT_SCOPE)
  endif()
endfunction()

include_guard(GLOBAL)

macro (return_unless)
  foreach (var ${ARGN})
    if (NOT ${var})
      return()
    endif()
  endforeach()
endmacro()

macro (continue_unless)
  foreach (var ${ARGN})
    if (NOT ${var})
      continue()
    endif()
  endforeach()
endmacro()

macro (break_unless)
  foreach (var ${ARGN})
    if (NOT ${var})
      break()
    endif()
  endforeach()
endmacro()

macro (halt_unless package)
  foreach (var ${ARGN})
    if (NOT ${package}_${var})
      return()
    endif()
  endforeach()
endmacro()
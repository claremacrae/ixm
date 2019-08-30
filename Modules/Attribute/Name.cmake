include_guard(GLOBAL)

function (ixm_attribute_name name)
  if (NOT ARGN)
    return()
  endif()
  parse(${ARGN} @ARGS=? DOMAIN)
  assign(domain ? DOMAIN PROJECT_NAME : "IXM")
  # XXX: Does CMake consider Project and project to be the same name?
  string(TOLOWER "${domain}" domain)
  string(TOLOWER "${name}" name)
  # This can easily be made better
  list(LENGTH ARGN length)
  if (length GREATER 1)
    list(GET ARGN 0 action)
    set(valid CONCAT APPEND ASSIGN)
    if (action IN_LIST valid)
      list(REMOVE_AT ARGN 0)
      if (action STREQUAL "CONCAT")
        set(action "APPEND_STRING")
      elseif (action STREQUAL "ASSIGN")
        unset(action)
      endif()
    else()
      unset(action)
    endif()
  endif()
  # FIXME: Does not actually work if one of them isn't defined (lol)
  set_property(GLOBAL PROPERTY ${action} "attr:${domain}:${name}" ${ARGN})
endfunction()
include_guard(GLOBAL)

# TODO: Handle setting colors via properties
# XXX: log settings should be stored as global properties, not variables?
# to make logging easier, each of error/warn/info/debug/trace should call the
# logging equivalent
# TODO: The best way to handle manually outputing to JSON or structured output or color output
#       would be to rely on an event system or sorts.

# ERROR > WARN > INFO > DEBUG > TRACE
# PANIC | FATAL | NOTICE are always shown
function (log level)
  get_property(IXM_LOG_LEVEL GLOBAL PROPERTY ixm::log::level)
  list(APPEND levels PANIC FATAL NOTICE ERROR WARN INFO DEBUG TRACE)
  if (NOT level IN_LIST levels)
    fatal("log(${level}) is not a supported logging level")
  endif()
  if (level STREQUAL "NOTICE")
    ixm_log_prepare(text ${ARGN})
    ixm_log_notice("${text}")
    return()
  elseif (level STREQUAL "FATAL")
    ixm_log_prepare(text ${ARGN})
    ixm_log_fatal("${text}")
    return()
  elseif(level STREQUAL "PANIC")
    # TODO: Move all of this to ixm_log_panic
    list(JOIN ARGN " " text)
    string(PREPEND text "! PANIC:")
    string(APPEND text " !")
    message(FATAL_ERROR "${.tomato}${text}${.default}")
    #ixm_log_panic("${text}")
    return()
  elseif (NOT IXM_LOG_LEVEL)
    return()
  endif()
  ixm_log_prepare(text ${ARGN})
  # XXX: There has to be a better way to check if we can log
  set(trace-levels DEBUG INFO WARN ERROR)
  set(debug-levels INFO WARN ERROR)
  set(info-levels WARN ERROR)
  set(warn-levels ERROR)
  if (level STREQUAL "TRACE" AND NOT (IXM_LOG_LEVEL IN_LIST trace-levels))
    ixm_log_trace(${text})
  elseif (level STREQUAL "DEBUG" AND NOT (IXM_LOG_LEVEL IN_LIST debug-levels))
    ixm_log_debug(${text})
  elseif (level STREQUAL "INFO" AND NOT (IXM_LOG_LEVEL IN_LIST info-levels))
    ixm_log_info(${text})
  elseif (level STREQUAL "WARN" AND NOT (IXM_LOG_LEVEL IN_LIST warn-levels))
    ixm_log_warn(${text})
  elseif (level STREQUAL "ERROR" AND IXM_LOG_LEVEL)
    ixm_log_error(${text})
  endif()
endfunction()

function (ixm_log_out type color text)
  get_property(pretty-output GLOBAL PROPERTY ixm::log::color)
  if (NOT pretty-output)
    unset(.${color})
    unset(.default)
  endif()
  message(${type} "${.${color}}${text}${.default}")
endfunction ()

function (ixm_log_trace text)
  ixm_log_file("${text}")
  set(type STATUS)
  if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.15)
    set(type TRACE)
  endif()
  ixm_log_out("${type}" lemon-chiffon "${text}")
endfunction()

function (ixm_log_debug text)
  ixm_log_file("${text}")
  set(type "STATUS")
  if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.15)
    set(type DEBUG)
  endif()
  ixm_log_out(${type} medium-spring-green "${text}")
endfunction()

function (ixm_log_info text)
  ixm_log_file("${text}")
  ixm_log_out(STATUS steel-blue "${text}")
endfunction()

function (ixm_log_warn text)
  #string(TIMESTAMP time "[%Y-%m-%dT%H:%M:%S]")
  #file(RELATIVE_PATH file "${CMAKE_SOURCE_DIR}" "${CMAKE_CURRENT_LIST_FILE}")
  ixm_log_file("${text}")
  ixm_log_out(STATUS gold "${text}")
  #ixm_log_out(STATUS default "${time} ${.gold}level${.default}=WARN ${.gold}file${.default}=${file} ${.gold}message${.default}=${text}")
endfunction()

# Prevents generation but *does not* stop processing
function (ixm_log_error)
  ixm_log_file("${text}")
  ixm_log_out(SEND_ERROR crimson "${text}")
endfunction()

function (ixm_log_notice text)
  ixm_log_file("${text}")
  set(type STATUS)
  if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.15)
    set(type NOTICE)
  endif()
  ixm_log_out("${type}" antique-white "${text}")
endfunction()

# Immediately stops CMake from continuing
function (ixm_log_fatal text)
  ixm_log_file("${text}")
  ixm_log_out(FATAL_ERROR red "${text}")
endfunction()

function (ixm_log_panic text)
  ixm_log_file("${text}")
  ixm_log_out(FATAL_ERROR tomato "${text}")
endfunction()

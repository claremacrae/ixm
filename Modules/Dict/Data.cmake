include_guard(GLOBAL)

function (ixm_dict_serialize dict result)
  ixm_dict_keys(${dict} keys)
  foreach (key IN LISTS keys)
    ixm_dict_get(${dict} ${key} value)
    if (NOT value STREQUAL "")
      string(REPLACE ";" "${+US}" value "${value}")
      string(REPLACE "\n" "${+NEL}" value "${value}")
      string(REPLACE "\r" "${+IDX}" value "${value}")
      list(APPEND output "${key}${+RS}${value}")
    endif()
  endforeach()
  list(JOIN output "\n" output)
  set(${result} ${output} PARENT_SCOPE)
endfunction()

function (ixm_dict_load dict)
  void(FROM data matched)
  parse(${ARGN} @ARGS=1 FROM)
  if (NOT FROM)
    log(FATAL "dict(LOAD) missing 'FROM' parameter")
  endif()
  ixm_dict_filepath(FROM "${FROM}" "ixm")
  if (NOT EXISTS "${FROM}")
    return()
  endif()
  ixm_dict_create(${dict})
  file(READ "${FROM}" data)
  string(STRIP "${data}" data)
  string(REPLACE "\n" ";" data "${data}")
  foreach (line IN LISTS data)
    string(REPLACE "${+NEL}" "\n" line "${line}")
    string(REPLACE "${+IDX}" "\r" line "${line}")
    string(REPLACE "${+RS}" ";" entry "${line}")
    list(GET entry 0 key)
    list(GET entry 1 val)
    string(REPLACE "${+US}" ";" val "${val}")
    ixm_dict_assign(${dict} ${key} ${val})
  endforeach()
endfunction()

function (ixm_dict_save dict)
  void(INTO keys value output)
  parse(${ARGN} @ARGS=1 INTO)
  if (NOT INTO)
    log(FATAL "dict(SAVE) missing 'INTO' parameter")
  endif()
  ixm_dict_noop(${dict})
  ixm_dict_serialize(${dict} output)
  ixm_dict_filepath(INTO "${INTO}" "ixm")
  file(WRITE "${INTO}" "${output}")
endfunction()

function (ixm_dict_json dict)
  parse(${ARGN}  @ARGS=1 INTO)
  if (NOT INTO)
    log(FATAL "dict(JSON) missing 'INTO' parameter")
  endif()
  ixm_dict_noop(${dict})
  dict(KEYS ${dict} keys)
  foreach (key IN LISTS keys)
    ixm_dict_get(${dict} ${key} value)
    list(LENGTH value length)
    if (NOT DEFINED value)
      set(json-text "null")
    elseif (length GREATER 1)
      ixm_dict_json_array(json-text ${value})
    else()
      ixm_dict_json_value(json-text ${value})
    endif()
    list(APPEND json-elements "\"${key}\":${json-text}")
  endforeach()
  list(JOIN json-elements "," json-object)
  ixm_dict_filepath(filepath "${INTO}" "json")
  file(WRITE "${filepath}" "{${json-object}}")
endfunction()

function (ixm_dict_json_value result value)
  set(false-literals OFF NO FALSE N IGNORE NOTFOUND)
  set(true-literals ON TRUE YES Y)
  if (value IN_LIST true-literals)
    set(${result} "true" PARENT_SCOPE)
  elseif (value IN_LIST false-literals OR value MATCHES ".*-NOTFOUND$")
    set(${result} "false" PARENT_SCOPE)
  elseif (value MATCHES "(^-?[0-9]+$|^-?(0|[1-9][0-9]+)([.][0-9]+)?$)")
    set(${result} ${value} PARENT_SCOPE)
  else()
    set(${result} "\"${value}\"" PARENT_SCOPE)
  endif()
endfunction()

function (ixm_dict_json_array result)
  foreach (value IN LISTS ARGN)
    ixm_dict_json_value(json-text ${value})
    list(APPEND json-array "${json-text}")
  endforeach()
  list(JOIN json-array "," json-text)
  set(${result} "[${json-text}]" PARENT_SCOPE)
endfunction()

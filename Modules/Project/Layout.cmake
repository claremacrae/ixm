include_guard(GLOBAL)

function (ixm_project_layout_discovery layout)
  ixm_project_layout_search_paths(path ${layout})
  foreach (path IN LISTS paths)
    if (EXISTS "${path}")
      set_property(GLOBAL PROPERTY IXM_CURRENT_LAYOUT_NAME ${layout})
      set_property(GLOBAL PROPERTY IXM_CURRENT_LAYOUT_FILE ${path})
      return()
    endif()
  endforeach()
  fatal("Could not discover layout '${layout}'")
endfunction()

function (ixm_project_layout_search_paths var layout)
  foreach (dir IN LISTS IXM_LAYOUT_PATH CMAKE_MODULE_PATH IXM_ROOT)
    list(APPEND ${var} "${dir}/layouts/${layout}.cmake")
    list(APPEND ${var} "${dir}/${layout}/layout.cmake")
    list(APPEND ${var} "${dir}/${layout}.cmake")
  endforeach()
  ixm_parent_scope(${var})
endfunction()

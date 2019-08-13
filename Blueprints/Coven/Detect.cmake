include_guard(GLOBAL)

function (coven_detect_directory var dir)
  set(detected OFF)
  if (IS_DIRECTORY "${PROJECT_SOURCE_DIR}/${dir}")
    set(detected ON)
  endif()
  dict(INSERT coven::detect::${PROJECT_NAME} ${var} ${detected})
endfunction ()

function (coven_detect_launchers)
  find_package(SCCache)
  set(target SCCache::SCCache)

  if (NOT TARGET SCCache::SCCache)
    find_package(CCache)
    set(target CCache::CCache)
  endif()

  if (NOT TARGET ${target})
    return()
  endif()

  get_property(enabled-languages GLOBAL PROPERTY ENABLED_LANGUAGES)
  foreach (language IN ITEMS CXX C Rust)
    if (NOT language IN_LIST enabled-languages)
      continue()
    endif()
    if (DEFINED CMAKE_${language}_COMPILER_LAUNCHER)
      continue()
    endif()
    get_property(CMAKE_${language}_COMPILER_LAUNCHER
      TARGET ${target}
      PROPERTY IMPORTED_LOCATION)
    upvar(CMAKE_${language}_COMPILER_LAUNCHER)
  endforeach()
endfunction()

function (coven_detect_gohugo out-var)
  foreach (extension IN ITEMS toml yaml json)
    if (EXISTS "${PROJECT_SOURCE_DIR}/docs/config.${extension}")
      find_package(Hugo)
      break()
    endif()
  endforeach()
endfunction ()

function (coven_detect_jekyll out-var)
  if (EXISTS "${PROJECT_SOURCE_DIR}/docs/_config.yml")
    find_package(Jekyll)
  endif()
endfunction ()

function (coven_detect_mkdocs out-var)
  if (EXISTS "${PROJECT_SOURCE_DIR}/docs/mkdocs.yml")
    find_package(MkDocs)
  endif()
endfunction ()

function (coven_detect_sphinx out-var)
  if (EXISTS "${PROJECT_SOURCE_DIR}/docs/conf.py")
    find_package(Sphinx)
  endif()
endfunction()
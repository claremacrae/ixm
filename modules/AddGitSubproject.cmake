include_guard(GLOBAL)

include(ParentScope)
include(Git)

function (add_git_subproject name path tag)
  git(${name} ${path} ${tag})
  add_subdirectory(${${name}_SOURCE_DIR} ${${name}_BINARY_DIR} EXCLUDE_FROM_ALL)
endfunction ()

function(add_github_subproject repository tag)
  get_filename_component(name ${repository} NAME)
  github(${repository} ${tag})
  add_subdirectory(${${name}_SOURCE_DIR} ${${name}_BINARY_DIR} EXCLUDE_FROM_ALL)
endfunction ()

function(add_gitlabg_subproject repository tag)
  get_filename_component(name ${repository} NAME)
  gitlab(${repository} ${tag})
  add_subdirectory(${${name}_SOURCE_DIR} ${${name}_BINARY_DIR} EXCLUDE_FROM_ALL)
endfunction ()

function(add_bitbucket_subproject repository tag)
  get_filename_component(name ${repository} NAME)
  bitbucket(${repository} ${tag})
  add_subdirectory(${${name}_SOURCE_DIR} ${${name}_BINARY_DIR} EXCLUDE_FROM_ALL)
endfunction ()

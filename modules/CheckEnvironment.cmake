include_guard(GLOBAL)

include(PushState)

push_module_path(CheckEnvironment)
include(CompilerFlagExists)
include(HeaderExists)
include(SymbolExists)
include(TypeExists)
pop_module_path()

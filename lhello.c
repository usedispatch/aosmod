#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include "hello.h"

// Lua-visible function that calls our C hello()
static int l_hello(lua_State *L) {
    const char *name = luaL_checkstring(L, 1);
    hello(name);
    return 0;  // No return values on Lua stack
}

// Table of Lua functions we expose in this module
static const luaL_Reg lhello_functions[] = {
    {"hello", l_hello},
    {NULL, NULL}  // Sentinel
};

// This is the module entry point:  require("lhello") => calls luaopen_lhello
int luaopen_lhello(lua_State *L) {
    luaL_newlib(L, lhello_functions);
    return 1;
}

# flutter_with_lua

A use dart ffi api with lua to flutter project

use ffi api package `dart_lua_ffi`


## Getting Started

```dart
    import 'package:ffi/ffi.dart';
    import 'package:flutter_with_lua/flutter_with_lua.dart';

     final LuaFFI _luaFFI = FlutterWithLua.getLuaFFI()!;
        _luaFFI.luaLLoadString(
            luaStatePointer,
            """function calcfunction()
                return 1+1
              end"""
                .toNativeUtf8());
        _luaFFI.luaPcallK(luaStatePointer, 0, 0, 0, LUA_MULTRET, 0);
        _luaFFI.luaGetGlobal(luaStatePointer, "calcfunction".toNativeUtf8());
        _luaFFI.luaPcallK(luaStatePointer, 0, 1, 0, LUA_MULTRET, 0);
        final res = _luaFFI.luaToNumberX(luaStatePointer, 0, C_NULL_POINTER);
```
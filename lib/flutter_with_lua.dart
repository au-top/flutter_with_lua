

import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:dart_lua_ffi/dart_lua_ffi.dart';

/// export
export 'package:dart_lua_ffi/dart_lua_ffi.dart';

class FlutterWithLua {
  static LuaFFI? _onlyLoadLua;
  static LuaFFI? getLuaFFI(){
    if(_onlyLoadLua!=null) {
      return _onlyLoadLua!;
    }
    if(Platform.isAndroid){
      _onlyLoadLua=LuaFFI(dynamicLibraryPath: "liblua-543-android.so");
    }
    return _onlyLoadLua;
  }
}


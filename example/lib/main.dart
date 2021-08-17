import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_with_lua/flutter_with_lua.dart';

void main() {
  runApp(const MyApp());
}

class TestFunction extends StatelessWidget {
  final Future<bool> Function() testFunction;

  const TestFunction({Key? key, required this.testFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: testFunction(),
      builder: (bc, fstate) {
        if (fstate.hasError) {
          return const Icon(Icons.close_rounded);
        }
        if (fstate.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }
        if(fstate.data!){
          return const Icon(Icons.done_rounded,color: Colors.green,);
        }else{
          return const Icon(Icons.close_rounded,color: Colors.red,);
        }
      },
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LuaFFI _luaFFI = FlutterWithLua.getLuaFFI()!;
  late final luaStatePointer = _luaFFI.luaLNewState();

  _MyAppState();

  @override
  void initState() {
    _luaFFI.luaOpenLibs(luaStatePointer);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.extension),
                title: Text("Test mul lua ffi "),
                trailing: TestFunction(
                  testFunction: () async {
                    final LuaFFI luaFFIA = FlutterWithLua.getLuaFFI()!;
                    final LuaFFI luaFFIB = FlutterWithLua.getLuaFFI()!;
                    return _luaFFI == luaFFIA && luaFFIA == luaFFIB;
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.calculate_outlined),
                title: Text("Test calc "),
                trailing: TestFunction(
                  testFunction: () async {
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
                    return res.toInt() == 2;
                  },
                ),
              )
            ],
            mainAxisSize: MainAxisSize.min,
          ),
        ),
      ),
    );
  }
}

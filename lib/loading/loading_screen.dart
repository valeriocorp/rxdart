import 'dart:async';

import 'package:flutter/material.dart';
import 'package:testingrxdart/loading/loading_screen_controller.dart';

class LoadingScreen {
  //singleton para la funcion de carga
  LoadingScreen._sharedInstance();
  static late final LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? controller;
  void show({required BuildContext context, required String text}){
    if (controller?.update(text) ?? false) {
      return;
    }else{
      controller = _showOverlay(context: context, text: text);
    }
  }

  void hide(){
    controller?.close();
    controller = null;
  }

  LoadingScreenController _showOverlay({
    required BuildContext context,
    required String text,
  }){
    final _text = StreamController<String>();
    _text.add(text);
    final renderBox = context.findRenderObject() as RenderBox;
    final avalibleSize = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
                constraints: BoxConstraints(
                  maxWidth: avalibleSize.width * 0.8,
                  minWidth: avalibleSize.width * 0.5,
                  maxHeight: avalibleSize.height * 0.8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       const SizedBox(height: 10,),
                        const CircularProgressIndicator(),
                       const  SizedBox(height: 10,),
                        StreamBuilder<String>(
                          stream: _text.stream,
                          builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.requireData,
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return const SizedBox();
                          
                            
                          }
                          },),
                      ],
                    ),
                  ),
                  ),
            ),
          ),
        );
      },
    );
    final state = Overlay.of(context);
    state?.insert(overlay);

    return LoadingScreenController(
      close: ()  {
        _text.close();
        overlay.remove();
        return true;
      },
      update: (String newText)  {
         _text.add(newText);
         return true;
      },
    );
  }
}
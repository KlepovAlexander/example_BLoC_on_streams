import 'dart:async';

import 'package:flutter/material.dart';

enum ColorEvent { event_red, event_green }

class ColorBloc {
  //поток для событий
  Color _color = Colors.red;
  final _inputEventController = StreamController<ColorEvent>();

  StreamSink<ColorEvent> get inputEventSink => _inputEventController.sink;

// поток для передачи нового состояния, который будет содержать в себе тип color
  final _outputStateController = StreamController<Color>();

  Stream<Color> get outputStateStream =>
      _outputStateController.stream; // геттер для выходного потока состояния

  //метод,который преобразовывает события в новое состояние(event)в данном случае меняем цвет
  void _mapEventToState(ColorEvent event) {
    if (event == ColorEvent.event_red) {
      _color = Colors.red;
    } else if (event == ColorEvent.event_green) {
      _color = Colors.green;
    } else {
      throw Exception('Wrong Event Type');
    }
//добавление в выходной поток после получения нового состояния(события)(передали новое состояние через sink используя метод add)
    _outputStateController.sink.add(_color);
  }

  // подписка на прослушивание выходного потока для нового состояния
  //подписываемся на поток и обрабатываем события,пришедшие со стороны ui и передаём их в новый стейт через mapEventToState
  ColorBloc() {
    _inputEventController.stream.listen(_mapEventToState);
  }

  //по окончанию работы потока,его нужно закрыть через метод dispose.
  void dispose() {
    _inputEventController.close();
    _outputStateController.close();
  }
}

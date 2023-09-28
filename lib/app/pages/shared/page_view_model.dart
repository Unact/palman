import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PageViewModel<T, P> extends Cubit<T> {
  PageViewModel(T state) : super(state) {
    initViewModel();
  }

  P get status;

  @mustCallSuper
  Future<void> initViewModel() async {}

  @override
  void emit(T state) {
    if (!isClosed) super.emit(state);
  }
}

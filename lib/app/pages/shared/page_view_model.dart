import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/app/repositories/base_repository.dart';

abstract class PageViewModel<T, P> extends Cubit<T> {
  PageViewModel(T state, [this.listenForRepos = const []]) : super(state) {
    initViewModel();
  }

  P get status;

  final List<BaseRepository> listenForRepos;

  @mustCallSuper
  Future<void> initViewModel() async {
    for (var el in listenForRepos) {
      el.addListener(loadData);
    }
    await loadData();
  }

  @protected
  Future<void> loadData();

  @override
  void emit(T state) {
    if (!isClosed) super.emit(state);
  }

  @override
  Future<void> close() async {
    for (var el in listenForRepos) {
      el.removeListener(loadData);
    }

    await super.close();
  }
}

import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:photo_anywhere/screens/photo/photo_actions.dart';
import 'package:photo_anywhere/shared/app_state.dart';

class PhotoViewModel extends BaseModel<AppState> {
  PhotoViewModel();

  ValueChanged<PhotoViewModel> onListPhotos;

  PhotoViewModel initialize() {
    return this;
  }

  PhotoViewModel.build({
    @required this.onListPhotos,
  }) : super ();

  @override
  PhotoViewModel fromStore() => PhotoViewModel.build(
    onListPhotos: (PhotoViewModel vm) => dispatch(ListPhotosAction(vm)),
  );
}

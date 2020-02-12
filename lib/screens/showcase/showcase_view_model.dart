import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:photo_anywhere/screens/showcase/showcase_actions.dart';
import 'package:photo_anywhere/shared/app_state.dart';

class ShowcaseViewModel extends BaseModel<AppState> {
  ShowcaseViewModel();

  ValueChanged<ShowcaseViewModel> onShowcasePhotos;

  ShowcaseViewModel initialize() {
    return this;
  }

  ShowcaseViewModel.build({
    @required this.onShowcasePhotos,
  }) : super ();

  @override
  ShowcaseViewModel fromStore() => ShowcaseViewModel.build(
    onShowcasePhotos: (ShowcaseViewModel vm) => dispatch(ShowcasePhotosAction(vm)),
  );
}

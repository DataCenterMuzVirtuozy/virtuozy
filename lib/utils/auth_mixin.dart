
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app_bloc.dart';

mixin AuthMixin<T extends StatefulWidget> on State<T> {
  bool get notAuthorized => context.read<AppBloc>().state.authStatusCheck != AuthStatusCheck.authenticated;
  bool get moderation => context.read<AppBloc>().state.authStatusCheck == AuthStatusCheck.moderation;

  void showAuthMessage(context) {

  }
}

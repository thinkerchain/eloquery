import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thinkerchain_stack_eloquery/cubit/eloquery_client_cubit.dart';

class EloqueryClientBuilder extends StatefulWidget {
  const EloqueryClientBuilder({super.key, required this.builder});
  final Widget Function(BuildContext context) builder;

  @override
  State<EloqueryClientBuilder> createState() => _EloqueryClientBuilderState();
}

class _EloqueryClientBuilderState extends State<EloqueryClientBuilder> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return BlocProvider(
        create: (context) => EloqueryClientCubit(),
        child: _EloqueryRenderWidget(builder: widget.builder),
      );
    });
  }
}

class _EloqueryRenderWidget extends StatefulWidget {
  const _EloqueryRenderWidget({super.key, required this.builder});
  final Widget Function(BuildContext context) builder;

  @override
  State<_EloqueryRenderWidget> createState() => _EloqueryRenderWidgetState();
}

class _EloqueryRenderWidgetState extends State<_EloqueryRenderWidget> {
  @override
  void initState() {
    super.initState();
    context.read<EloqueryClientCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}

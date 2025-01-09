import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thinkerchain_stack_eloquery/cubit/eloquery_client_cubit.dart';
import 'package:thinkerchain_stack_eloquery/cubit/eloquery_cubit.dart';
import 'package:thinkerchain_stack_eloquery/data/eloquery_response.dart';

class EloqueryBuilder<T> extends StatefulWidget {
  EloqueryBuilder({
    super.key,
    required this.queryKey,
    required this.queryFn,
    required this.builder,
    EloqueryResponse? eloqueryData,
  }) : eloqueryData = eloqueryData ?? EloqueryResponse();

  // QUERY DATA
  final EloqueryResponse eloqueryData;
  // QUERY STALE TIME
  final List<String> queryKey;
  final FutureOr<T> Function() queryFn;
  final Widget Function(BuildContext, EloqueryState<T>, Function refetch)
      builder;

  @override
  State<EloqueryBuilder> createState() => _EloqueryBuilderState<T>();
}

class _EloqueryBuilderState<T> extends State<EloqueryBuilder<T>> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return BlocProvider(
        create: (context) {
          final queryClientData = context
              .read<EloqueryClientCubit>()
              .getExistingData(widget.queryKey) as EloqueryResponse<T>?;
          return QueryCubitImpl<T>(
              eloqueryData: queryClientData,
              queryKey: widget.queryKey,
              queryFn: widget.queryFn,
              builder: widget.builder);
        },
        child: RenderWidget<T>(widget: widget),
      );
    });
  }
}

class RenderWidget<T> extends StatefulWidget {
  const RenderWidget({
    super.key,
    required this.widget,
  });

  final EloqueryBuilder<T> widget;

  @override
  State<RenderWidget> createState() => _RenderWidgetState<T>();
}

class _RenderWidgetState<T> extends State<RenderWidget<T>> {
  @override
  void initState() {
    super.initState();
    refetch();
  }

  void refetch() {
    context.read<QueryCubitImpl<T>>().runQueryFun();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return BlocConsumer<EloqueryClientCubit, EloqueryClientState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Builder(builder: (context) {
            return BlocConsumer<QueryCubitImpl<T>, EloqueryState<T>>(
                listener: (context, state) {
              if (state is EloquerySuccess<T>) {
                context.read<EloqueryClientCubit>().addData((
                  queryKey: widget.widget.queryKey,
                  eloqueryData: state.data,
                ));
              }
            }, builder: (context, state) {
              return widget.widget.builder(context, state, refetch);
            });
          });
        },
      );
    });
  }
}

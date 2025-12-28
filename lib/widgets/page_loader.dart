// 1. Define a simple class to hold the state
import 'package:flutter/material.dart';

class _LoaderState {
  final bool isLoading;
  final String? message;
  const _LoaderState({this.isLoading = false, this.message});
}

class PageLoader extends StatefulWidget {
  const PageLoader({
    super.key,
    required this.child,
    this.userInteractionEnabled = false,
  });

  final Widget child;
  final bool userInteractionEnabled;

  @override
  State<PageLoader> createState() => _PageLoaderState();

  static InheritedLoading of(BuildContext context) =>
      context
              .getElementForInheritedWidgetOfExactType<InheritedLoading>()!
              .widget
          as InheritedLoading;
}

class _PageLoaderState extends State<PageLoader> {
  // 2. Update ValueNotifier to use the custom state class
  late final stateNotifier = ValueNotifier(const _LoaderState());

  @override
  void dispose() {
    stateNotifier.dispose();
    super.dispose();
  }

  // 3. Update setLoading to accept an optional message
  void setLoading(bool isLoading, {String? message}) {
    Future.microtask(
      () => stateNotifier.value = _LoaderState(
        isLoading: isLoading,
        message: message,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<_LoaderState>(
      valueListenable: stateNotifier,
      child: widget.child,
      builder: (context, state, child) {
        return InheritedLoading(
          isLoading: state.isLoading,
          // 4. Expose the message via the show method
          show: ({String? message}) => setLoading(true, message: message),
          hide: () => setLoading(false),
          child: Stack(
            children: [
              IgnorePointer(
                ignoring: state.isLoading && !widget.userInteractionEnabled,
                child: child,
              ),
              if (state.isLoading)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.7),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const LoadingSpin(),
                        // 5. Render the text if it exists
                        if (state.message != null &&
                            state.message!.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Material(
                            color: Colors.transparent,
                            child: Text(
                              state.message!,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class LoadingSpin extends StatelessWidget {
  const LoadingSpin({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeCap: StrokeCap.round,
      strokeWidth: 6,
      color: color,
    );
  }
}

@immutable
class InheritedLoading extends InheritedWidget {
  const InheritedLoading({
    super.key,
    required this.isLoading,
    required super.child,
    required this.show,
    required this.hide,
  });

  final bool isLoading;

  // 6. Update the callback signature
  final void Function({String? message}) show;
  final VoidCallback hide;

  @override
  bool updateShouldNotify(covariant InheritedLoading oldWidget) {
    return oldWidget.isLoading != isLoading;
  }
}

extension PageLoaderX on BuildContext {
  // 7. Update extension to pass the parameter
  void showLoader({String? message}) =>
      PageLoader.of(this).show(message: message);

  void hideLoader() => PageLoader.of(this).hide();
}

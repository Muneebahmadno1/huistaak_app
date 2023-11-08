//Intro
import 'dart:async';
import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Intro {
  bool _removed = false;
  double? _widgetWidth;
  double? _widgetHeight;
  Offset? _widgetOffset;
  OverlayEntry? _overlayEntry;
  int _currentStepIndex = 0;
  Widget? _stepWidget;
  List<Map> _configMap = [];
  List<GlobalKey> _globalKeys = [];
  late Duration _animationDuration;
  late Size _lastScreenSize;
  final th = _Throttling(duration: const Duration(milliseconds: 500));

  /// The mask color of step page
  final Color maskColor;

  /// Current step page index
  /// 2021-03-31 @caden
  /// I don’t remember why this parameter was exposed at the time,
  /// it seems to be useless, and there is a bug in this one, so let’s block it temporarily.
  // int get currentStepIndex => _currentStepIndex;

  /// No animation
  final bool noAnimation;

  // Click on whether the mask is allowed to be closed.
  final bool maskClosable;

  /// The method of generating the content of the guide page,
  /// which will be called internally by [Intro] when the guide page appears.
  /// And will pass in some parameters on the current page through [StepWidgetParams]
  final Widget Function(StepWidgetParams params) widgetBuilder;

  /// [Widget] [padding] of the selected area, the default is [EdgeInsets.all(8)]
  final EdgeInsets padding;

  /// [Widget] [borderRadius] of the selected area, the default is [BorderRadius.all(Radius.circular(4))]
  final BorderRadiusGeometry borderRadius;

  /// How many steps are there in total
  final int stepCount;

  /// The highlight widget tapped callback
  final void Function(IntroStatus introStatus)? onHighlightWidgetTap;

  /// Create an Intro instance, the parameter [stepCount] is the number of guide pages
  /// [widgetBuilder] is the method of generating the guide page, and returns a [Widget] as the guide page
  Intro({
    required this.widgetBuilder,
    required this.stepCount,
    this.maskColor = const Color.fromRGBO(0, 0, 0, .6),
    this.noAnimation = false,
    this.maskClosable = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.padding = const EdgeInsets.all(0),
    this.onHighlightWidgetTap,
  }) : assert(stepCount > 0) {
    _animationDuration = noAnimation
        ? const Duration(milliseconds: 0)
        : const Duration(milliseconds: 300);
    for (int i = 0; i < stepCount; i++) {
      _globalKeys.add(GlobalKey());
      _configMap.add({});
    }
  }

  List<GlobalKey> get keys => _globalKeys;

  /// Set the configuration of the specified number of steps
  ///
  /// [stepIndex] Which step of configuration needs to be modified
  /// [padding] Padding setting
  /// [borderRadius] BorderRadius setting
  void setStepConfig(
    int stepIndex, {
    EdgeInsets? padding,
    BorderRadiusGeometry? borderRadius,
  }) {
    assert(stepIndex >= 0 && stepIndex < stepCount);
    _configMap[stepIndex] = {
      'padding': padding,
      'borderRadius': borderRadius,
    };
  }

  /// Set the configuration of multiple steps
  ///
  /// [stepsIndex] Which steps of configuration needs to be modified
  /// [padding] Padding setting
  /// [borderRadius] BorderRadius setting
  void setStepsConfig(
    List<int> stepsIndex, {
    EdgeInsets? padding,
    BorderRadiusGeometry? borderRadius,
  }) {
    assert(stepsIndex
        .every((stepIndex) => stepIndex >= 0 && stepIndex < stepCount));
    stepsIndex.forEach((index) {
      setStepConfig(
        index,
        padding: padding,
        borderRadius: borderRadius,
      );
    });
  }

  void _getWidgetInfo(GlobalKey globalKey) {
    if (globalKey.currentContext == null) {
      throw FlutterIntroException(
        'The current context is null, because there is no widget in the tree that matches this global key.'
        ' Please check whether the globalKey in intro.keys has forgotten to bind.',
      );
    }

    EdgeInsets? currentConfig = _configMap[_currentStepIndex]['padding'];
    RenderBox renderBox =
        globalKey.currentContext!.findRenderObject() as RenderBox;
    _widgetWidth = renderBox.size.width +
        (currentConfig?.horizontal ?? padding.horizontal);
    _widgetHeight =
        renderBox.size.height + (currentConfig?.vertical ?? padding.vertical);
    _widgetOffset = Offset(
      renderBox.localToGlobal(Offset.zero).dx -
          (currentConfig?.left ?? padding.left),
      renderBox.localToGlobal(Offset.zero).dy -
          (currentConfig?.top ?? padding.top),
    );
  }

  Widget _widgetBuilder({
    double? width,
    double? height,
    BlendMode? backgroundBlendMode,
    required double left,
    required double top,
    double? bottom,
    double? right,
    BorderRadiusGeometry? borderRadiusGeometry,
    Widget? child,
    VoidCallback? onTap,
  }) {
    final decoration = BoxDecoration(
      color: Colors.white,
      backgroundBlendMode: backgroundBlendMode,
      borderRadius: borderRadiusGeometry,
    );
    return AnimatedPositioned(
      duration: _animationDuration,
      left: left,
      top: top,
      bottom: bottom,
      right: right,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          padding: padding,
          decoration: decoration,
          width: width,
          height: height,
          child: child,
          duration: _animationDuration,
        ),
      ),
    );
  }

  void _showOverlay(
    BuildContext context,
    GlobalKey globalKey,
  ) {
    _overlayEntry = new OverlayEntry(
      builder: (BuildContext context) {
        Size screenSize = MediaQuery.of(context).size;

        if (screenSize.width != _lastScreenSize.width ||
            screenSize.height != _lastScreenSize.height) {
          _lastScreenSize = screenSize;
          th.throttle(() {
            _createStepWidget(context);
            _overlayEntry!.markNeedsBuild();
          });
        }

        return _DelayRenderedWidget(
          removed: _removed,
          childPersist: true,
          duration: _animationDuration,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    maskColor,
                    BlendMode.srcOut,
                  ),
                  child: Stack(
                    children: [
                      _widgetBuilder(
                        backgroundBlendMode: BlendMode.dstOut,
                        left: 0,
                        top: 0,
                        right: 0,
                        bottom: 0,
                        onTap: maskClosable
                            ? () {
                                if (stepCount - 1 == _currentStepIndex) {
                                  _onFinish();
                                } else {
                                  _onNext(context);
                                }
                              }
                            : null,
                      ),
                      _widgetBuilder(
                        width: _widgetWidth,
                        height: _widgetHeight,
                        left: _widgetOffset!.dx,
                        top: _widgetOffset!.dy,
                        // Skipping through the intro very fast may cause currentStepIndex to out of bounds
                        // I have tried to fix it, here is just to make the code safer
                        // https://github.com/tal-tech/flutter_intro/issues/22
                        borderRadiusGeometry: _currentStepIndex < stepCount
                            ? _configMap[_currentStepIndex]['borderRadius'] ??
                                borderRadius
                            : borderRadius,
                        onTap: onHighlightWidgetTap != null
                            ? () {
                                IntroStatus introStatus = getStatus();
                                onHighlightWidgetTap!(introStatus);
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
                _DelayRenderedWidget(
                  duration: _animationDuration,
                  child: _stepWidget,
                ),
              ],
            ),
          ),
        );
      },
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _onNext(BuildContext context) {
    if (_currentStepIndex + 1 < stepCount) {
      _currentStepIndex++;
      _renderStep(context);
    }
  }

  void _onPrev(BuildContext context) {
    if (_currentStepIndex - 1 >= 0) {
      _currentStepIndex--;
      _renderStep(context);
    }
  }

  void _onFinish() {
    if (_overlayEntry == null) return;
    _removed = true;
    _overlayEntry!.markNeedsBuild();
    Timer(_animationDuration, () {
      if (_overlayEntry == null) return;
      _overlayEntry!.remove();
      _overlayEntry = null;
    });
  }

  void _createStepWidget(BuildContext context) {
    _getWidgetInfo(_globalKeys[_currentStepIndex]);
    Size screenSize = MediaQuery.of(context).size;
    Size widgetSize = Size(_widgetWidth!, _widgetHeight!);

    _stepWidget = widgetBuilder(StepWidgetParams(
      screenSize: screenSize,
      size: widgetSize,
      onNext: _currentStepIndex == stepCount - 1
          ? null
          : () {
              _onNext(context);
            },
      onPrev: _currentStepIndex == 0
          ? null
          : () {
              _onPrev(context);
            },
      offset: _widgetOffset,
      currentStepIndex: _currentStepIndex,
      stepCount: stepCount,
      onFinish: _onFinish,
    ));
  }

  void _renderStep(BuildContext context) {
    _createStepWidget(context);
    _overlayEntry!.markNeedsBuild();
  }

  /// Trigger the start method of the guided operation
  ///
  /// [context] Current environment [BuildContext]
  void start(BuildContext context) {
    _lastScreenSize = MediaQuery.of(context).size;
    _removed = false;
    _currentStepIndex = 0;
    _createStepWidget(context);
    _showOverlay(
      context,
      _globalKeys[_currentStepIndex],
    );
  }

  /// Destroy the guide page and release all resources
  void dispose() {
    _onFinish();
  }

  /// Get intro instance current status
  IntroStatus getStatus() {
    bool isOpen = _overlayEntry != null;
    IntroStatus introStatus = IntroStatus(
      isOpen: isOpen,
      currentStepIndex: _currentStepIndex,
    );
    return introStatus;
  }
}

class _Throttling {
  late Duration _duration;
  Timer? _timer;

  _Throttling({Duration duration = const Duration(seconds: 1)})
      : assert(!duration.isNegative) {
    _duration = duration;
  }

  void throttle(Function func) {
    if (_timer == null) {
      _timer = Timer(_duration, () {
        Function.apply(func, []);
        _timer = null;
      });
    }
  }
}

class StepWidgetBuilder {
  @visibleForTesting
  static Map smartGetPosition({
    required Size size,
    required Size screenSize,
    required Offset offset,
  }) =>
      _smartGetPosition(size: size, screenSize: screenSize, offset: offset);

  static Map _smartGetPosition({
    required Size size,
    required Size screenSize,
    required Offset offset,
  }) {
    double height = size.height;
    double width = size.width;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    double bottomArea = screenHeight - offset.dy - height;
    double topArea = screenHeight - height - bottomArea;
    double rightArea = screenWidth - offset.dx - width;
    double leftArea = screenWidth - width - rightArea;
    Map position = Map();
    position['crossAxisAlignment'] = CrossAxisAlignment.start;

    if (topArea > bottomArea) {
      position['bottom'] = bottomArea + height + 16;
    } else {
      position['top'] = offset.dy + height + 12;
    }

    if (leftArea > rightArea) {
      position['right'] = rightArea <= 0 ? 16.0 : rightArea;
      position['crossAxisAlignment'] = CrossAxisAlignment.end;
      position['width'] = min(leftArea + width - 16, screenWidth * 0.618);
    } else {
      position['left'] = offset.dx <= 0 ? 16.0 : offset.dx;
      position['width'] = min(rightArea + width - 16, screenWidth * 0.618);
    }

    /// The distance on the right side is very large, it is more beautiful on the right side
    if (rightArea > 0.8 * topArea && rightArea > 0.8 * bottomArea) {
      position['left'] = offset.dx + width + 16;
      position['top'] = offset.dy - 4;
      position['bottom'] = null;
      position['right'] = null;
      position['width'] = min<double>(position['width'], rightArea * 0.8);
    }

    /// The distance on the left is large, it is more beautiful on the left side
    if (leftArea > 0.8 * topArea && leftArea > 0.8 * bottomArea) {
      position['right'] = rightArea + width + 16;
      position['top'] = offset.dy - 4;
      position['bottom'] = null;
      position['left'] = null;
      position['crossAxisAlignment'] = CrossAxisAlignment.end;
      position['width'] = min<double>(position['width'], leftArea * 0.8);
    }

    return position;
  }

  /// Use default theme.
  ///
  /// * [texts] is an array of text on the guide page.
  /// * [buttonTextBuilder] is the method of generating button text.
  /// * [maskClosable] has remove to intro class, deprecated and not working now, use like below.
  /// {@tool snippet}
  /// dart
  /// final Intro intro = Intro(
  ///   maskClosable: true,
  /// );
  ///
  /// {@end-tool}
  /// the parameters are the current page index and the total number of pages in sequence.
  static Widget Function(StepWidgetParams params) useDefaultTheme({
    required List<String> texts,
    required String Function(int currentStepIndex, int stepCount)
        buttonTextBuilder,
    @deprecated bool? maskClosable,
  }) {
    return (StepWidgetParams stepWidgetParams) {
      int currentStepIndex = stepWidgetParams.currentStepIndex;
      int stepCount = stepWidgetParams.stepCount;
      Offset offset = stepWidgetParams.offset!;

      Map position = _smartGetPosition(
        screenSize: stepWidgetParams.screenSize,
        size: stepWidgetParams.size,
        offset: offset,
      );

      return Stack(
        children: [
          Positioned(
            left: position['left'],
            top: position['top'],
            bottom: position['bottom'],
            right: position['right'],
            child: SizedBox(
              width: 90.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DottedBorder(
                    color: Colors.white,
                    strokeCap: StrokeCap.round,
                    dashPattern: [8, 4],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    child: ClipRRect(
                      child: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: Text(
                          currentStepIndex > texts.length - 1
                              ? ''
                              : texts[currentStepIndex],
                          softWrap: true,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    height: 28,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white,
                        ),
                        overlayColor: MaterialStateProperty.all<Color>(
                          Colors.white.withOpacity(0.1),
                        ),
                        side: MaterialStateProperty.all<BorderSide>(
                          const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 8,
                          ),
                        ),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          const StadiumBorder(),
                        ),
                      ),
                      onPressed: () {
                        if (stepCount - 1 == currentStepIndex) {
                          stepWidgetParams.onFinish();
                        } else {
                          stepWidgetParams.onNext!();
                        }
                      },
                      child: Text(
                        buttonTextBuilder(currentStepIndex, stepCount),
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    };
  }

  /// Use advanced theme.
  ///
  /// * [widgetBuilder] the widget returned by this method will be displayed on the screen.
  /// it's worth noting that the maximum display width of the widget will be limited by the current screen width.
  static Widget Function(StepWidgetParams params) useAdvancedTheme({
    required Widget Function(StepWidgetParams params) widgetBuilder,
  }) {
    return (StepWidgetParams stepWidgetParams) {
      Offset offset = stepWidgetParams.offset!;

      Map position = _smartGetPosition(
        screenSize: stepWidgetParams.screenSize,
        size: stepWidgetParams.size,
        offset: offset,
      );

      return Stack(
        children: [
          Positioned(
            left: 5.w,
            top: position['top'],
            bottom: position['bottom'],
            right: 5.w,
            child: SizedBox(
              width: position['width'],
              child: widgetBuilder(stepWidgetParams),
            ),
          ),
        ],
      );
    };
  }
}

class StepWidgetParams {
  /// Return to the previous guide page method, or null if there is none
  final VoidCallback? onPrev;

  /// Enter the next guide page method, or null if there is none
  final VoidCallback? onNext;

  /// End all guide page methods
  final VoidCallback onFinish;

  /// Which guide page is currently displayed, starting from 0
  final int currentStepIndex;

  /// Total number of guide pages
  final int stepCount;

  /// The width and height of the screen
  final Size screenSize;

  /// The width and height of the highlighted component
  final Size size;

  /// The coordinates of the upper left corner of the highlighted component
  final Offset? offset;

  StepWidgetParams({
    this.onPrev,
    this.onNext,
    required this.onFinish,
    required this.screenSize,
    required this.size,
    required this.currentStepIndex,
    required this.stepCount,
    required this.offset,
  });

  @override
  String toString() {
    return 'StepWidgetParams(currentStepIndex: $currentStepIndex, stepCount: $stepCount, size: $size, screenSize: $screenSize, offset: $offset)';
  }
}

class IntroStatus {
  /// Flutter_intro is showing on the screen or not
  final bool isOpen;

  /// Current step page index
  final int currentStepIndex;

  IntroStatus({
    required this.isOpen,
    required this.currentStepIndex,
  });

  @override
  String toString() {
    return 'IntroStatus(isOpen: $isOpen, currentStepIndex: $currentStepIndex)';
  }
}

class FlutterIntroException implements Exception {
  final dynamic message;

  FlutterIntroException([this.message]);

  String toString() {
    Object? message = this.message;
    if (message == null) return "FlutterIntroException";
    return "FlutterIntroException: $message";
  }
}

class _DelayRenderedWidget extends StatefulWidget {
  /// Sub-elements that need to fade in and out
  final Widget? child;

  /// [child] Whether to continue rendering, that is, the animation will only be once
  final bool childPersist;

  /// Animation duration
  final Duration duration;

  /// [child] need to be removed (hidden)
  final bool removed;

  const _DelayRenderedWidget({
    Key? key,
    this.removed = false,
    required this.duration,
    this.child,
    this.childPersist = false,
  }) : super(key: key);
  @override
  _DelayRenderedWidgetState createState() => _DelayRenderedWidgetState();
}

class _DelayRenderedWidgetState extends State<_DelayRenderedWidget> {
  double opacity = 0;
  Widget? child;
  late Timer timer;

  /// Time interval between animations
  final Duration durationInterval = const Duration(milliseconds: 100);
  @override
  void initState() {
    super.initState();
    child = widget.child;
    timer = Timer(durationInterval, () {
      if (mounted) {
        setState(() {
          opacity = 1;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    // setUserHomeFirstTime(false);//,l
  }

  @override
  void didUpdateWidget(_DelayRenderedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    var duration = widget.duration;
    if (widget.removed) {
      setState(() {
        opacity = 0;
      });
      return;
    }
    if (!identical(oldWidget.child, widget.child)) {
      if (widget.childPersist) {
        setState(() {
          child = widget.child;
        });
      } else {
        setState(() {
          opacity = 0;
        });
        Timer(
          Duration(
            milliseconds:
                duration.inMilliseconds + durationInterval.inMilliseconds,
          ),
          () {
            setState(() {
              child = widget.child;
              opacity = 1;
            });
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: widget.duration,
      child: child,
    );
  }
}

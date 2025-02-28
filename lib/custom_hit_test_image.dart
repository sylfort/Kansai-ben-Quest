// custom_hit_test_image.dart

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomHitTestImage extends SingleChildRenderObjectWidget {
  const CustomHitTestImage({
    super.key,
    required Widget child,
    required this.hitTestRects,
  }) : super(child: child);

  final List<Rect> hitTestRects;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _CustomHitTestRenderObject(hitTestRects: hitTestRects);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _CustomHitTestRenderObject renderObject,
  ) {
    renderObject.hitTestRects = hitTestRects;
  }
}

class _CustomHitTestRenderObject extends RenderProxyBox {
  _CustomHitTestRenderObject({required this.hitTestRects});

  List<Rect> hitTestRects;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    for (final rect in hitTestRects) {
      if (rect.contains(position)) {
        return super.hitTest(result, position: position);
      }
    }
    return false;
  }
}

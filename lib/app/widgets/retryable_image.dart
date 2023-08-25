import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class RetryableImage extends StatefulWidget {
  final String imageUrl;
  final void Function()? onTap;
  final Color color;

  RetryableImage({
    Key? key,
    required this.imageUrl,
    this.onTap,
    this.color = Colors.red
  }) : super(key: key);

  @override
  State<RetryableImage> createState() => _RetryableImageState();
}

class _RetryableImageState extends State<RetryableImage> {
  final _rebuildNotifier = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _rebuildNotifier,
      builder: (context, value, child) => CachedNetworkImage(
        key: ValueKey(value),
        imageUrl: widget.imageUrl,
        imageBuilder: (context, imageProvider) {
          return GestureDetector(
            onTap: widget.onTap,
            child: Container(decoration: BoxDecoration(image: DecorationImage(image: imageProvider)))
          );
        },
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(color: widget.color)
        ),
        errorWidget: (context, url, error) => IconButton(
          icon: Icon(Icons.refresh, color: widget.color),
          tooltip: 'Загрузить заново',
          onPressed: () {
            _rebuildNotifier.value = const Uuid().v1();
          }
        )
      )
    );
  }
}

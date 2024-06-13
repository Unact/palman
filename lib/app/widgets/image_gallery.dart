part of 'widgets.dart';

class ImageGallery extends StatefulWidget {
  final int curIdx;
  final List<RetryableImage> images;
  final FutureOr<void> Function(int idx) onDelete;

  ImageGallery({
    required this.curIdx,
    required this.images,
    required this.onDelete,
    super.key
  });

  @override
  State createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  late int _curIdx = widget.curIdx;
  late List<Widget> images = widget.images;
  late final _pageController = PageController(initialPage: _curIdx);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(images.isEmpty ? '' : '${_curIdx + 1} из ${images.length}'),
        actions: [
          IconButton(
            onPressed: () async {
              await widget.onDelete(_curIdx);
              images.removeAt(_curIdx);

              if (images.isEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pop(context);
                });
                return;
              }
              setState(() { _curIdx = _curIdx > 0 ? _curIdx - 1 : 0; });
            },
            icon: const Icon(Icons.delete),
            tooltip: 'Удалить фотографию',
          )
        ]
      ),
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onVerticalDragEnd: (details) => Navigator.pop(context),
        child: Container(
          color: Colors.black,
          child: PhotoViewGallery.builder(
            pageController: _pageController,
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions.customChild(
                initialScale: 0.8,
                child: images[_curIdx]
              );
            },
            onPageChanged: (idx) => setState(() { _curIdx = idx; }),
            itemCount: images.length
          ),
        ),
      )
    );
  }
}

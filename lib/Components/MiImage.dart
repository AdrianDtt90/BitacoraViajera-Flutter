import 'dart:io';

import 'package:flutter/material.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MiImage extends StatefulWidget {
  final String url;
  final int fileType; // 0: External, 1:Internal, 2:Assets

  MiImage({Key key, this.url, this.fileType: 0}) : super(key: key);

  @override
  _MiImageState createState() => _MiImageState();
}

class _MiImageState extends State<MiImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ImageViewer(url: widget.url, fileType: widget.fileType)),
          );
        },
        child: getImageWidget(widget.url, widget.fileType));
  }

  Widget getImageWidget(String url, int fileType) {
    switch (fileType) {
      case 0:
        return Image.network(url);
      case 1:
        return Image.file(File(url));
      case 2:
        return Image.asset(url);
      default:
    }
  }
}

class ImageViewer extends StatelessWidget {
  final String url;
  final int fileType;

  ImageViewer({Key key, this.url, this.fileType: 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url == null) return Container();

    return Container(
        color: Colors.red,
        child: PhotoView(
          imageProvider: getImageWidget(url, fileType),
        ));
  }

  dynamic getImageWidget(String url, int fileType) {
    switch (fileType) {
      case 0:
        return NetworkImage(url);
      case 1:
        return FileImage(File(url));
      case 2:
        return AssetImage(url);
      default:
    }
  }
}

dynamic getImagesViewer(List<String> urls) {
  if (urls == null) return Container();

  List<PhotoViewGalleryPageOptions> listImages = new List();
  int count = 1;

  urls.forEach((url) {
    listImages.add(PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(url),
      heroTag: "Image " + count.toString(),
    ));

    count = count + 1;
  });

  if (listImages.length == 0) return Container();

  return Container(
      child: PhotoViewGallery(
    pageOptions: listImages,
    backgroundDecoration: BoxDecoration(color: Colors.black87),
  ));
}

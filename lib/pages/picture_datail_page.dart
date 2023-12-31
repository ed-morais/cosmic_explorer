import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/picture_data.dart';
import '../providers/image_data_provider.dart';

class PictureDetailPage extends StatefulWidget {
  final ImageData pictuteDetails;
  const PictureDetailPage({
    super.key,
    required this.pictuteDetails,
  });

  @override
  State<PictureDetailPage> createState() => _PictureDetailPageState();
}

class _PictureDetailPageState extends State<PictureDetailPage> {
  late bool isFavorite;
  @override
  void initState() {
    final providerImage =
        Provider.of<ImageDataProvider>(context, listen: false);
    isFavorite = false;
    _isFavorite(providerImage);
    super.initState();
  }

  void _isFavorite(providerImage) {
    setState(() {
      final index = providerImage.saves
          .indexWhere((element) => widget.pictuteDetails.date == element.date);
      index == -1 ? isFavorite = false : isFavorite = true;
    });
  }

  void toggleFavorite(ImageDataProvider providerImage) {
    setState(() {
      final index = providerImage.saves
          .indexWhere((element) => widget.pictuteDetails.date == element.date);
      if (index == -1) {
        providerImage.addSavesImages(widget.pictuteDetails);
        isFavorite = true;
      } else {
        providerImage.removeSavedImages(index);
        isFavorite = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerImage = Provider.of<ImageDataProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Image details',
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              widget.pictuteDetails.imageUrl,
              fit: BoxFit.cover,
            ),
            Card(
              margin: EdgeInsets.zero,
              elevation: 10.0,
              child: ClipPath(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 5,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(widget.pictuteDetails.title),
                        leading: const Icon(Icons.title_outlined),
                      ),
                      ListTile(
                        title: Text(widget.pictuteDetails.date),
                        leading: const Icon(Icons.date_range),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ReadMoreText(
                          widget.pictuteDetails.explanation,
                          textAlign: TextAlign.justify,
                          trimLines: 3,
                          preDataTextStyle:
                              const TextStyle(fontWeight: FontWeight.w500),
                          style: TextStyle(color: Theme.of(context).hintColor),
                          colorClickableText: Theme.of(context).primaryColor,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Show more',
                          trimExpandedText: ' show less',
                        ),
                      ),
                      ListTile(
                        title: Text(widget.pictuteDetails.copyright),
                        leading: const Icon(Icons.copyright),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            widget.pictuteDetails.videoUrl != ''
                ? Container(
                    margin: const EdgeInsetsDirectional.symmetric(
                        horizontal: 110.0, vertical: 30.0),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        var url = Uri.parse(widget.pictuteDetails.videoUrl);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).primaryColor),
                      ),
                      icon: const Icon(Icons.play_circle,
                        color: Colors.white,
                      ),
                      label: const Text("Play Video ",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                : const Text(''),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => toggleFavorite(providerImage),
        child: isFavorite
            ? const Icon(
                Icons.bookmarks,
                color: Colors.white,
              )
            : const Icon(
                Icons.bookmarks_outlined,
                color: Colors.white,
              ),
      ),
    );
  }
}

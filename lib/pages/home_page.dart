import 'package:astronomy_picture_app/app/config/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/image_data_provider.dart';
import '../widgets/image_card.dart';
import '../widgets/info_modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    loadRequest();
    super.initState();
  }

  loadRequest() async {
    final provider = Provider.of<ImageDataProvider>(context, listen: false);
    await provider.fetchImages();
    if (provider.status != 200) {
      debugPrint('Error >>>> : ${provider.status}');
      // alertError();
    }
  }

  Future<void> reloadRequest() async {
    final provider = Provider.of<ImageDataProvider>(context, listen: false);
    provider.clearList();
    await provider.fetchImages();
    if (provider.status != 200) {
      debugPrint('Error >>>>> : ${provider.status}');
      // alertError();
    }
  }

  void alertError() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: ListTile(
        leading: const Icon(
          Icons.error,
          color: Colors.red,
        ),
        title: Text(
          'Sorry, we had trouble loading the app.',
          style: TextStyle(color: Colors.red.shade300),
        ),
      ),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: 'try again',
        onPressed: () {
          reloadRequest();
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final providerImage = Provider.of<ImageDataProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: const Text(
          'Astronomy App',
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const InfoModal();
                },
              );
            },
            icon: const Icon(Icons.group),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(RoutesApp.settings);
            },
            icon: const Icon(Icons.settings),
          )
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: providerImage.images.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: reloadRequest,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: providerImage.images.length,
                itemBuilder: (context, index) => ImageCard(
                  imageData: providerImage.images[index],
                  index: index + 1,
                ),
              ),
            ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => reloadRequest(),
        backgroundColor: Colors.purple.shade800,
        child: const Icon(
          Icons.refresh_rounded,
          size: 30.0,
        ),
      ),
    );
  }
}

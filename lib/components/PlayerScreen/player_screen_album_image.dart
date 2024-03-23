import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/current_album_image_provider.dart';
import '../album_image.dart';

class PlayerScreenAlbumImage extends StatelessWidget {
  const PlayerScreenAlbumImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FinampQueueInfo?>(
      stream: GetIt.instance<QueueService>().getQueueStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // show loading indicator
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 24,
                  offset: const Offset(0, 4),
                  color: Colors.black.withOpacity(0.15),
                )
              ],
            ),
            alignment: Alignment.center,
            child: AlbumImage(
              imageListenable: currentAlbumImageProvider,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        );
      },
    );
  }
}

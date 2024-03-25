import 'package:balanced_text/balanced_text.dart';
import 'package:finamp/components/PlayerScreen/player_buttons_more.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart' as jellyfin_models;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/queue_service.dart';
import '../favourite_button.dart';
import 'album_chip.dart';
import 'artist_chip.dart';

class SongNameContent extends StatelessWidget {
  const SongNameContent(
    this.targetHeight, {
    super.key,
  });

  final double targetHeight;

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

        final currentTrack = snapshot.data!.currentTrack!;

        final jellyfin_models.BaseItemDto? songBaseItemDto =
            currentTrack.item.extras!["itemJson"] != null
                ? jellyfin_models.BaseItemDto.fromJson(
                    currentTrack.item.extras!["itemJson"])
                : null;

        return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  alignment: Alignment.center,
                  constraints: BoxConstraints(
                    maxHeight: targetHeight < 223 ? 24 : 52,
                    maxWidth: 280,
                  ),
                  child: BalancedText(
                    currentTrack.item.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      height: 26 / 20,
                      fontWeight:
                          Theme.of(context).brightness == Brightness.light
                              ? FontWeight.w500
                              : FontWeight.w600,
                      overflow: TextOverflow.visible,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: targetHeight < 223 ? 1 : 2,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PlayerButtonsMore(item: songBaseItemDto),
                  Flexible(
                    child: ArtistChips(
                      baseItem: songBaseItemDto,
                      backgroundColor:
                          IconTheme.of(context).color!.withOpacity(0.1),
                    ),
                  ),
                  FavoriteButton(
                    item: songBaseItemDto,
                    onToggle: (isFavorite) {
                      songBaseItemDto!.userData!.isFavorite = isFavorite;
                      currentTrack.item.extras!["itemJson"] =
                          songBaseItemDto.toJson();
                    },
                  ),
                ],
              ),
              AlbumChip(
                item: songBaseItemDto,
                backgroundColor: IconTheme.of(context).color!.withOpacity(0.1),
                key: songBaseItemDto?.album == null
                    ? null
                    : ValueKey("${songBaseItemDto!.album}-album"),
              ),
            ],
          ),
        );
      },
    );
  }
}

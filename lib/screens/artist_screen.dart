import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../components/AlbumScreen/album_screen_content.dart';
import '../components/AlbumScreen/song_list_tile.dart';
import '../components/ArtistScreen/artist_download_button.dart';
import '../components/MusicScreen/music_screen_tab_view.dart';
import '../components/favourite_button.dart';
import '../components/now_playing_bar.dart';
import '../models/finamp_models.dart';
import '../models/jellyfin_models.dart';
import '../services/finamp_settings_helper.dart';
import '../services/jellyfin_api_helper.dart';

class ArtistScreen extends StatelessWidget {
  const ArtistScreen({
    Key? key,
    this.widgetArtist,
  }) : super(key: key);

  static const routeName = "/music/artist";

  /// The artist to show. Can also be provided as an argument in a named route
  final BaseItemDto? widgetArtist;

  @override
  Widget build(BuildContext context) {
    final BaseItemDto artist = widgetArtist ??
        ModalRoute.of(context)!.settings.arguments as BaseItemDto;

    return Scaffold(
      appBar: AppBar(
        title: Text(artist.name ?? "Unknown Name"),
        actions: [
          // this screen is also used for genres, which can't be favorited
          if (artist.type != "MusicGenre") FavoriteButton(item: artist),
          ArtistDownloadButton(artist: artist)
        ],
      ),
      body: ArtistScreenContent(
        parent: artist,
      ),
      bottomNavigationBar: const NowPlayingBar(),
    );
  }
}

class ArtistScreenContent extends StatefulWidget {
  const ArtistScreenContent({Key? key, required this.parent}) : super(key: key);

  final BaseItemDto parent;

  @override
  State<ArtistScreenContent> createState() => _ArtistScreenContentState();
}

class _ArtistScreenContentState extends State<ArtistScreenContent> {
  Future<List<BaseItemDto>?>? songs;
  JellyfinApiHelper jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  @override
  Widget build(BuildContext context) {
    songs ??= jellyfinApiHelper.getItems(
      parentItem: widget.parent,
      filters: "Artist=${widget.parent.name}",
      sortBy: "PlayCount",
      includeItemTypes: "Audio",
      isGenres: false,
    );

    return FutureBuilder(
        future: songs,
        builder: (context, snapshot) {
          // TODO how the hell do I sort this gosh darn List...
          var orderedSongs = snapshot.data?.map((_) => _).toList() ?? [];
          orderedSongs.sort(
              (a, b) => a.userData!.playCount.compareTo(b.userData!.playCount));

          return Scrollbar(
              child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
              const SliverToBoxAdapter(
                  child: Text(
                "Top Songs",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
              SongsSliverList(
                childrenForList: orderedSongs.take(5).toList(),
                parent: widget.parent,
              ),
              const SliverPadding(padding: EdgeInsets.fromLTRB(0, 15.0, 0, 0)),
              const SliverToBoxAdapter(
                  child: Text(
                "Albums",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
            ],
            body: MusicScreenTabView(
                tabContentType: TabContentType.albums,
                parentItem: widget.parent,
                isFavourite: false),
          ));
        });
  }
}

class SongsSliverList extends StatefulWidget {
  const SongsSliverList({
    Key? key,
    required this.childrenForList,
    required this.parent,
    this.onDelete,
  }) : super(key: key);

  final List<BaseItemDto> childrenForList;
  final BaseItemDto parent;
  final BaseItemDtoCallback? onDelete;

  @override
  State<SongsSliverList> createState() => _SongsSliverListState();
}

class _SongsSliverListState extends State<SongsSliverList> {
  final GlobalKey<SliverAnimatedListState> sliverListKey =
      GlobalKey<SliverAnimatedListState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // When user selects song from disc other than first, index number is
    // incorrect and song with the same index on first disc is played instead.
    // Adding this offset ensures playback starts for nth song on correct disc.

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final BaseItemDto item = widget.childrenForList[index];

          BaseItemDto removeItem() {
            late BaseItemDto item;

            setState(() {
              item = widget.childrenForList.removeAt(index);
            });

            return item;
          }

          return SongListTile(
            item: item,
            children: widget.childrenForList,
            index: index,
            parentId: widget.parent.id,
            parentName: widget.parent.name,
            onDelete: () {
              final item = removeItem();
              if (widget.onDelete != null) {
                widget.onDelete!(item);
              }
            },
            isInPlaylist: widget.parent.type == "Playlist",
            // show artists except for this one scenario
            showArtists: !(
                // we're on album screen
                widget.parent.type == "MusicAlbum"
                    // "hide song artists if they're the same as album artists" == true
                    &&
                    FinampSettingsHelper
                        .finampSettings.hideSongArtistsIfSameAsAlbumArtists
                    // song artists == album artists
                    &&
                    setEquals(
                        widget.parent.albumArtists?.map((e) => e.name).toSet(),
                        item.artists?.toSet())),
          );
        },
        childCount: widget.childrenForList.length,
      ),
    );
  }
}

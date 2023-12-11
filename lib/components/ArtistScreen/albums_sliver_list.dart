import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/jellyfin_models.dart';
import '../../services/finamp_settings_helper.dart';
import '../AlbumScreen/album_screen_content.dart';
import 'album_list_tile.dart';

class AlbumsSliverList extends StatefulWidget {
  const AlbumsSliverList({
    Key? key,
    required this.childrenForList,
    required this.parent,
    this.onDelete,
  }) : super(key: key);

  final List<BaseItemDto> childrenForList;
  final BaseItemDto parent;
  final BaseItemDtoCallback? onDelete;

  @override
  State<AlbumsSliverList> createState() => _AlbumsSliverListState();
}

class _AlbumsSliverListState extends State<AlbumsSliverList> {
  final GlobalKey<SliverAnimatedListState> sliverListKey =
      GlobalKey<SliverAnimatedListState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

          return AlbumListTile(
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
            // show artists except for this one scenario
            // TODO we could do it here like with the song sliver list
            // showArtists: false,
          );
        },
        childCount: widget.childrenForList.length,
      ),
    );
  }
}

import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:scout_app_enhanced/logic/scout_data_providers/scout_badges_provider.dart';
import 'package:scout_app_enhanced/logic/scout_data_storage/database.dart';

class ScoutBadgeListTile extends ConsumerWidget {
  const ScoutBadgeListTile({super.key, required this.badge});
  final ScoutBadgeItem badge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.23,
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            autoClose: true,
            flex: 1,
            onPressed: (context) {
              ref
                  .read(scoutBadgesNotifierProvider.notifier)
                  .toggleBadgeLikeStatusByUuid(badge.uuid);
            },
            backgroundColor: const Color(0xFFFFB700),
            foregroundColor: Colors.white,
            icon: !badge.isLiked ? Icons.star : Icons.star_border,
            label: !badge.isLiked ? 'Like' : "Unlike",
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          if (context.canPop()) {
            Navigator.of(context).pop();
          }
          context.push("/home/badge/${badge.name.replaceAll(" ", "_")}");
        },
        leading: SizedBox(
          height: 50,
          width: 50,
          child: CachedNetworkImageBuilder(
            url: badge.imageUrl,
            builder: (image) {
              return Center(child: Image.file(image));
            },
            // Optional Placeholder widget until image loaded from url
            placeHolder: const Center(
              child: SizedBox(
                  width: 10, height: 10, child: CircularProgressIndicator()),
            ),
            // Optional error widget
            errorWidget: const Icon(Icons.error_outline),
            // Optional describe your image extensions default values are; jpg, jpeg, gif and png
          ),
        ),
        title: Text(badge.name),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          if (badge.isLiked) const Icon(Icons.star),
          if (badge.status != null && badge.status!.isCompleted)
            const Icon(Icons.check),
        ]),
      ),
    );
  }
}

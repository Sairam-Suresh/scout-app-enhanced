import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:scout_app_enhanced/logic/scout_data_storage/database.dart';

// hhh
class ScoutBadgeCard extends HookWidget {
  const ScoutBadgeCard({super.key, required this.badge});
  final ScoutBadgeItem badge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go("/badge/${badge.name.replaceAll(" ", "_")}");
      },
      child: SizedBox(
          child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Center(
                child: Image.network(
                  badge.imageUrl,
                  width: 100,
                  height: 100,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Container()),
                  if (badge.status?.isCompleted != null &&
                      badge.status?.isCompleted == true)
                    const CircleAvatar(
                        radius: 12, child: Icon(Icons.check_circle)),
                ],
              ),
              // Expanded(
              //   child: AutoSizeText(
              //     badge.name!,
              //     minFontSize: 10,
              //     textAlign: TextAlign.center,
              //     style: const TextStyle(fontSize: 30),
              //   ),
              // )
            ],
          ),
        ),
      )),
    );
  }
}

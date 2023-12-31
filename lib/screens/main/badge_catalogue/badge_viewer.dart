import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scout_app_enhanced/logic/scout_data_providers/scout_badges_provider.dart';

class BadgeViewer extends HookConsumerWidget {
  const BadgeViewer({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var badgeFromDb = useMemoized(() => ref
        .read(scoutBadgesNotifierProvider.notifier)
        .obtainBadgeByName(name.replaceAll("_", " ")));
    var badge = useFuture(badgeFromDb);

    return Scaffold(
      appBar: AppBar(
        title: Text(name.replaceAll("_", " ")),
      ),
      body: (badge.hasData)
          ? Padding(
              padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Image.network(
                            badge.data!.imageUrl,
                            height: 170,
                            width: 170,
                          ),
                        ),
                      ),
                      if (badge.data!.status != null)
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (badge.data!.status!.completedDate != "")
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Completed on"),
                                        Text(
                                          badge.data!.status!.completedDate,
                                          style: const TextStyle(fontSize: 30),
                                        )
                                      ]),
                                if (badge.data!.status!.badgeGivenDate != "")
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Badge given on"),
                                        Text(
                                          badge.data!.status!.badgeGivenDate,
                                          style: const TextStyle(fontSize: 30),
                                        )
                                      ]),
                                if (badge.data!.status!.certGivenDate != null &&
                                    badge.data!.status!.certGivenDate != "")
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Certificate Given On"),
                                        Text(
                                          badge.data!.status!.certGivenDate!,
                                          style: const TextStyle(fontSize: 30),
                                        )
                                      ])
                              ]),
                        )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Html(data: badge.data!.description)
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

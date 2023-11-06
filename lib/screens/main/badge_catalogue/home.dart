import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scout_app_enhanced/logic/scout_data_providers/scout_badges_provider.dart';
import 'package:scout_app_enhanced/logic/scout_data_storage/database.dart';
import 'package:scout_app_enhanced/widgets/scout_badge_list_tile.dart';

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentBadges = useState<List<ScoutBadgeItem>>([]);
    var scoutBadges = ref.watch(scoutBadgesNotifierProvider);

    useEffect(() {
      if (scoutBadges.hasValue &&
          scoutBadges.value?.length != null &&
          scoutBadges.value!.isNotEmpty) {
        currentBadges.value = scoutBadges.value!;
      }
      return null;
    }, [scoutBadges.hasValue]);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Badge Catalogue'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            ref
                .read(scoutBadgesNotifierProvider.notifier)
                .scrapeScoutsWebsiteAndUpdateDb();
          },
          isExtended: true,
          label: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search),
              SizedBox(
                width: 10,
              ),
              Text(
                "Search",
                style: TextStyle(fontSize: 17),
              )
            ],
          ),
        ),
        body: ListView.builder(
          itemCount: currentBadges.value.length,
          itemBuilder: (context, index) =>
              ScoutBadgeListTile(badge: currentBadges.value[index]),
        ));
  }
}

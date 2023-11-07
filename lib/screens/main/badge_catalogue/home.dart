import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scout_app_enhanced/logic/scout_data_providers/scout_badges_provider.dart';
import 'package:scout_app_enhanced/logic/scout_data_storage/database.dart';
import 'package:scout_app_enhanced/widgets/scout_badge_list_tile.dart';

enum BadgeFilters { starred, completed }

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var filters = useState<Set<BadgeFilters>>({});

    // These are the badges obtained from the Database
    // We cant use this directly as it is asynchronous, so we use an effect instead
    var scoutBadges = ref.watch(scoutBadgesNotifierProvider);

    // This is the badge list obtained from the scoutBadges variable above
    // We use a useEffect Hook to get the data and place it in here
    var currentBadges = useState<List<ScoutBadgeItem>>([]);

    // This is the variable that we use in our widget code
    // Can be filtered accordingly (e.g. search) and can be reset using the "currentBadges" variable
    var filteredBadges = useState(currentBadges.value);

    var searchController = useTextEditingController();
    var searchText = useState("");

    useEffect(() {
      if (scoutBadges.hasValue &&
          scoutBadges.value?.length != null &&
          scoutBadges.value!.isNotEmpty) {
        currentBadges.value = scoutBadges.value!;
      }

      filteredBadges.value = [...currentBadges.value];

      if (searchText.value != "") {
        filteredBadges.value
            .removeWhere((element) => !element.name.contains(searchText.value));
        filteredBadges.value = [...filteredBadges.value];
      }

      if (filters.value.contains(BadgeFilters.starred)) {
        filteredBadges.value.removeWhere((element) => !element.isLiked);
        filteredBadges.value = [...filteredBadges.value];
      }

      if (filters.value.contains(BadgeFilters.completed)) {
        filteredBadges.value.removeWhere((element) =>
            element.status?.isCompleted == null ||
            !element.status!.isCompleted);
        filteredBadges.value = [...filteredBadges.value];
      }

      return null;
    }, [scoutBadges, searchText.value, filters.value]);

    return Scaffold(
        appBar: null,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SearchBar(
                      controller: searchController,
                      leading: const Padding(
                        padding: EdgeInsets.only(left: 8, top: 8, bottom: 8),
                        child: Icon(Icons.search),
                      ),
                      onChanged: (newSearch) {
                        searchText.value = newSearch;
                      },
                      trailing: searchController.text != ""
                          ? [
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: IconButton(
                                    onPressed: () {
                                      searchController.clear();
                                      searchText.value = "";
                                    },
                                    icon: const Icon(Icons.clear)),
                              )
                            ]
                          : null,
                      hintText: "Search for a Badge",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Filters: ",
                          style: TextStyle(fontSize: 25),
                        ),
                        ...BadgeFilters.values
                            .map((e) => Row(
                                  children: [
                                    FilterChip(
                                      label: Text(e.name),
                                      selected: filters.value.contains(e),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.padded,
                                      onSelected: (bool selected) {
                                        if (selected) {
                                          filters.value.add(e);
                                        } else {
                                          filters.value.remove(e);
                                        }

                                        filters.value = {...filters.value};
                                      },
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ))
                            .toList(),
                        Expanded(child: Container()),
                        if (filters.value.isNotEmpty)
                          IconButton(
                              onPressed: () {
                                filters.value = {};
                              },
                              icon: const Icon(Icons.filter_list_off))
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filteredBadges.value.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredBadges.value.length,
                        itemBuilder: (context, index) => ScoutBadgeListTile(
                            badge: filteredBadges.value[index]),
                      )
                    : (searchText.value != "" || filters.value.isNotEmpty)
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Oops",
                                  style: TextStyle(fontSize: 35),
                                ),
                                Text(
                                  "We could not find badges that match your search criteria. Please try again.",
                                  style: TextStyle(fontSize: 25),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          )
                        : const Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ));
  }
}

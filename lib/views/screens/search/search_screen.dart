import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shimmer/shimmer.dart';

import '../../../cubit/filter_cubit.dart';
import '../../../data/data_provider.dart';
import '../../../data/models/filter.dart';
import '../../../data/models/key_value.dart';
import '../../../data/models/region.dart';
import '../../../helpers/helper_functions.dart';
import '../../../res/theme.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_select.dart';
import '../../widgets/search_field.dart';
import '../create/select_category_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({
    Key? key,
    this.filter,
  }) : super(key: key);

  final Filter? filter;

  List<KeyValue<String>> sortTypes = [
    KeyValue(key: 'newest', value: 'Свежие объявления'),
    KeyValue(key: 'low_price', value: 'По цене (сначала дешевые)'),
    KeyValue(key: 'high_price', value: 'По цене (сначала дорогие)'),
    KeyValue(key: 'views', value: 'Самые просматриваемые'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FilterCubit(filter: filter)..fetchRegions(),
      child: BlocBuilder<FilterCubit, FilterState>(
        builder: (context, state) {
          final filterCubit = context.read<FilterCubit>();

          return Scaffold(
            appBar: AppBar(
              elevation: 1,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
              title: const Text('Поиск'),
              actions: [
                TextButton(
                  onPressed: () {
                    filterCubit.clearFilter();
                    context.read<DataProvider>().filter.value = null;
                  },
                  child: Text(
                    'очистить'.toUpperCase(),
                    style: TextStyle(color: context.theme.onPrimary),
                  ),
                ),
              ],
            ),
            floatingActionButton: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: const EdgeInsets.only(right: 10, bottom: 10, left: 42),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: state.resultsCount != null
                    ? () {
                        context.read<DataProvider>().filter.value =
                            state.filter;
                        Navigator.pop(context, state.filter);
                      }
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Показать результаты' +
                          (state.resultsCount != null
                              ? ': ${state.resultsCount}'
                              : ''),
                      style: const TextStyle(fontSize: 20),
                    ),
                    if (state.isLoadingResults) ...[
                      const SizedBox(width: 5),
                      const CircularProgressIndicator.adaptive(),
                    ]
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: context.theme.grey.withOpacity(0.4),
                    ),
                    child: Hero(
                      tag: 'search_bar_field',
                      child: SizedBox(
                        height: 40,
                        child: SearchField(
                          onStopEditing: (value) {
                            filterCubit.addToFilter(text: value);
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'Категория',
                      style: TextStyle(
                        fontSize: 18,
                        color: context.theme.greyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomCard(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      onTap: () async {
                        final category = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SelectCategoryScreen(),
                          ),
                        );
                        if (category != null) {
                          filterCubit.addToFilter(
                            category: category,
                            categoryId: category.id,
                          );
                        }
                      },
                      leading: const Icon(Feather.settings),
                      title: state.isLoadingCategory
                          ? Shimmer.fromColors(
                              child: const Text('Загрузка категорий...'),
                              baseColor: Colors.white,
                              highlightColor: Colors.grey,
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (state.filter?.category?.parent != null)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 3),
                                    child: Text(
                                      getParentsTree(
                                        state.filter!.category!.parent!,
                                      ),
                                    ),
                                  ),
                                Text(
                                  state.filter?.category?.name ??
                                      'Выбрать категорию',
                                  style: const TextStyle(fontSize: 13),
                                )
                              ],
                            ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomCard(
                    padding: EdgeInsets.zero,
                    child: CustomSelect<Region>(
                      list: state.regions,
                      displayItem: (item) => item.name.toString(),
                      title: 'Регион',
                      onChanged: (region) {
                        filterCubit.addToFilter(region: region);
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomCard(
                    padding: EdgeInsets.zero,
                    child: CustomSelect<KeyValue>(
                      list: sortTypes,
                      displayItem: (item) => item.value.toString(),
                      title: 'Сортировка',
                      onChanged: (value) =>
                          filterCubit.addToFilter(sortBy: value.key),
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomCard(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 15,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Есть фото'),
                            Switch.adaptive(
                              value: state.filter?.hasPhoto ?? false,
                              onChanged: (value) =>
                                  filterCubit.addToFilter(hasPhoto: value),
                            ),
                          ],
                        ),
                        const Divider(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Есть видео'),
                            Switch.adaptive(
                              value: state.filter?.hasVideo ?? false,
                              onChanged: (value) =>
                                  filterCubit.addToFilter(hasVideo: value),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

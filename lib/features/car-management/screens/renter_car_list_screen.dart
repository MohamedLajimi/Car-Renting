import 'package:car_renting/core/utils/debouncer.dart';
import 'package:car_renting/core/widgets/app_persistent_header_delegate.dart';
import 'package:car_renting/core/widgets/search_filter_bar.dart';
import 'package:car_renting/core/widgets/status_info_display.dart';
import 'package:car_renting/features/car-management/blocs/car_management_bloc/car_management_bloc.dart';
import 'package:car_renting/features/car-management/models/car_filter_params.dart';
import 'package:car_renting/features/car-management/models/car_model.dart';
import 'package:car_renting/features/car-management/routes/car_management_routes_names.dart';
import 'package:car_renting/features/car-management/widgets/active_filters_bar.dart';
import 'package:car_renting/features/car-management/widgets/car_filter_bottom_sheet.dart';
import 'package:car_renting/features/car-management/widgets/renter_car_card.dart';
import 'package:car_renting/features/car-management/widgets/renter_car_list_success_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RenterCarListScreen extends StatefulWidget {
  const RenterCarListScreen({super.key});

  @override
  State<RenterCarListScreen> createState() => _RenterCarListScreenState();
}

class _RenterCarListScreenState extends State<RenterCarListScreen> {
  final ScrollController _scrollController = .new();
  final TextEditingController _searchController = .new();
  late Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _getRenterCars();
    _debouncer = Debouncer(milliseconds: 300);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    _debouncer.dispose();
  }

  void _getRenterCars() {
    context.read<CarManagementBloc>().add(const GetRenterCarsRequested());
  }

  void _onScroll() {
    final state = context.read<CarManagementBloc>().state;
    if (state is CarListState &&
        !state.isLoadingMore &&
        state.hasNextPage &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8) {
      context.read<CarManagementBloc>().add(LoadMoreCarsRequested());
    }
  }

  void _onSearch(String query) {
    _debouncer.run(() {
      final currentState = context.read<CarManagementBloc>().state;
      CarFilterParams currentFilters = const CarFilterParams();

      if (currentState is CarListState) {
        currentFilters = currentState.filters;
      }
      context.read<CarManagementBloc>().add(
        GetRenterCarsRequested(
          filters: currentFilters.copyWith(searchQuery: query),
        ),
      );
    });
  }

  void _onClearFilters() {
    _searchController.clear();
    context.read<CarManagementBloc>().add(
      const GetRenterCarsRequested(filters: CarFilterParams()),
    );
  }

  void _onRemoveFilter(String filterKey) {
    final currentState = context.read<CarManagementBloc>().state;
    if (currentState is CarListState) {
      final updatedFilters = currentState.filters.removeFilter(filterKey);

      if (filterKey == 'search') {
        _searchController.clear();
      }

      context.read<CarManagementBloc>().add(
        GetRenterCarsRequested(filters: updatedFilters),
      );
    }
  }

  void _openFilterBottomSheet() async {
    final currentState = context.read<CarManagementBloc>().state;
    if (currentState is CarListState) {
      final result = await CarFilterBottomSheet.show(
        context,
        currentFilters: currentState.filters,
      );

      if (result != null) {
        context.read<CarManagementBloc>().add(
          GetRenterCarsRequested(filters: result),
        );
      }
    }
  }

  void _handleListener(BuildContext context, CarManagementState state) {
    if (state is CarManagementActionState && state.isSuccess) {
      _getRenterCars();
    }
  }

  bool _listenWhen(CarManagementState state) =>
      state is CarManagementActionState && (state.isSuccess || state.isError);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => context.pushNamed(CarManagementRoutesNames.addCar),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 32),
        child: BlocConsumer<CarManagementBloc, CarManagementState>(
          listenWhen: (previous, current) => _listenWhen(current),
          listener: _handleListener,
          buildWhen: (previous, current) => current is CarListState,
          builder: (context, state) {
            if (state is! CarListState) {
              return const Center(child: CircularProgressIndicator());
            }

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: AppPersistentHeaderDelegate(
                    height: 70,
                    child: SearchFilterBar(
                      searchHint: 'Search cars',
                      controller: _searchController,
                      onSearch: _onSearch,
                      onFilterTap: _openFilterBottomSheet,
                      hasFilters: state.filters.hasFilters,
                    ),
                  ),
                ),
                if (state.filters.hasFilters)
                  SliverPersistentHeader(
                    pinned: false,
                    delegate: AppPersistentHeaderDelegate(
                      height: 40,
                      child: ActiveFiltersBar(
                        filters: state.filters,
                        onRemoveFilter: _onRemoveFilter,
                        onClearAll: _onClearFilters,
                      ),
                    ),
                  ),
                _buildContentSlivers(state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContentSlivers(CarListState state) {
    if (state.isLoading) {
      final dummyList = CarModel.dummyList(5);
      return 
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Skeletonizer(
              enabled: true,
              child: RenterCarCard(car: dummyList[index]),
            ),
            childCount: dummyList.length,
          ),
        )
      ;
    }

    if (state.isError) {
      return 
        SliverFillRemaining(
          hasScrollBody: false,
          child: StatusInfoDisplay(
            icon: CupertinoIcons.exclamationmark_triangle,
            title: 'Oops !',
            description: context.tr(state.errorMessage!),
            actionText: context.tr('car_management.buttons.retry'),
            onAction: _getRenterCars,
          ),
        )
      ;
    }
    if (state.isSuccess && state.isEmpty) {
      final hasFilters = state.filters.hasFilters;
      final title = !hasFilters
          ? 'car_management.empty.fleet_title'
          : 'car_management.empty.no_results_title';
      final description = !hasFilters
          ? 'car_management.empty.fleet_desc'
          : 'car_management.empty.no_results_desc';

      return 
        SliverFillRemaining(
          hasScrollBody: false,
          child: StatusInfoDisplay(
            icon: CupertinoIcons.car_detailed,
            title: context.tr(title),
            description: context.tr(description),
            actionText: hasFilters
                ? context.tr('car_management.empty.clear_filters')
                : null,
            onAction: hasFilters ? _onClearFilters : null,
          ),
        )
      ;
    }
    return 
      RenterCarListSuccessView(
        cars: state.cars,
        isLoadingMore: state.isLoadingMore,
        hasReachedMax: !state.hasNextPage,
      )
    ;
  }
}

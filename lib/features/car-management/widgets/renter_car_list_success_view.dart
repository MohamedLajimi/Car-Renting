import 'package:car_renting/core/widgets/pagination_footer.dart';
import 'package:car_renting/features/car-management/models/car_model.dart';
import 'package:car_renting/features/car-management/widgets/renter_car_card.dart';
import 'package:flutter/cupertino.dart';

class RenterCarListSuccessView extends StatelessWidget {
  final List<CarModel> cars;
  final bool isLoadingMore;
  final bool hasReachedMax;

  const RenterCarListSuccessView({
    super.key,
    required this.cars,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index < cars.length) {
          return RenterCarCard(car: cars[index]);
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: PaginationFooter(
            noMoreToLoadText: '',
            isLoadingMore: isLoadingMore,
            hasReachedMax: hasReachedMax,
          ),
        );
      }, childCount: cars.length + 1),
    );
  }
}

import 'package:equatable/equatable.dart';

class PaginationResponse<T> extends Equatable {
  final List<T> items;
  final int totalCount;
  final bool hasNextPage;

  const PaginationResponse({
    required this.items,
    required this.totalCount,
    required this.hasNextPage,
  });

  @override
  List<Object?> get props => [items, totalCount, hasNextPage];
}
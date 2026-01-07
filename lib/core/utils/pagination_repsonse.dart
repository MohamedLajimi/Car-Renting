import 'package:equatable/equatable.dart';

class PaginationResponse<T> extends Equatable {
  final List<T> items;
  final int totalCount;
  final bool hasNextPage;
  final dynamic lastDoc;

  const PaginationResponse({
    required this.items,
    required this.totalCount,
    required this.hasNextPage,
    required this.lastDoc
  });

  @override
  List<Object?> get props => [items, totalCount, hasNextPage, lastDoc];
}

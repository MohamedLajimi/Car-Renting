part of 'car_form_cubit.dart';

class CarFormState extends Equatable {
  final CarParams params;
  final int sectionIndex;
  final bool nextEnabled;
  final bool canSubmit;

  const CarFormState({
    required this.params,
    this.sectionIndex = 0,
    this.nextEnabled = false,
    this.canSubmit = false,
  });

  CarFormState copyWith({
    CarParams? params,
    int? sectionIndex,
    bool? nextEnabled,
    bool? canSubmit,
  }) => CarFormState(
    params: params ?? this.params,
    sectionIndex: sectionIndex ?? this.sectionIndex,
    nextEnabled: nextEnabled ?? this.nextEnabled,
    canSubmit: canSubmit ?? this.canSubmit,
  );

  @override
  List<Object> get props => [params, sectionIndex, nextEnabled, canSubmit];
}

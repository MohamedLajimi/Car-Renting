import 'package:car_renting/core/utils/snackbar_utils.dart';
import 'package:car_renting/features/car-management/blocs/car_form_cubit/car_form_cubit.dart';
import 'package:car_renting/features/car-management/blocs/car_management_bloc/car_management_bloc.dart';
import 'package:car_renting/features/car-management/models/car_params.dart';
import 'package:car_renting/features/car-management/widgets/car_form_basic_section.dart';
import 'package:car_renting/features/car-management/widgets/car_form_header.dart';
import 'package:car_renting/features/car-management/widgets/car_form_location_and_availability_section.dart';
import 'package:car_renting/features/car-management/widgets/car_form_media_and_documents_section.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CarFormScreen extends StatefulWidget {
  final String? carId;
  const CarFormScreen({super.key, this.carId});

  @override
  State<CarFormScreen> createState() => _CarFormScreenState();
}

class _CarFormScreenState extends State<CarFormScreen> {
  late final PageController _pageController;

  final List<Map<String, dynamic>> _sections = [
    {
      'title': 'car_management.sections.basics',
      'subtitle': 'car_management.sections.basics_sub',
      'icon': Icons.directions_car,
    },
    {
      'title': 'car_management.sections.location',
      'subtitle': 'car_management.sections.location_sub',
      'icon': Icons.location_on,
    },
    {
      'title': 'car_management.sections.media',
      'subtitle': 'car_management.sections.media_sub',
      'icon': Icons.photo_library,
    },
  ];
  @override
  void initState() {
    super.initState();
    _getCarDetail();
    _pageController = PageController();
  }

  void _getCarDetail() {
    if (widget.carId != null) {
      context.read<CarManagementBloc>().add(
        GetCarDetailsRequested(widget.carId!),
      );
    }
  }

  String _screenTitle() => widget.carId == null
      ? context.tr('car_management.title_add')
      : context.tr('car_management.title_update');

  void _onPageChanged(int index) {
    context.read<CarFormCubit>().setSection(index);
  }

  void _goToSection(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onSubmit(CarParams params) {
    final event = params.id == null
        ? AddCarRequested(params: params)
        : UpdateCarRequested(params: params);
    context.read<CarManagementBloc>().add(event);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CarManagementBloc, CarManagementState>(
      listenWhen: (previous, current) =>
          (current is CarDetailState && current.car != null) ||
          (current is CarManagementActionState &&
              (current.type == ActionType.create ||
                  current.type == ActionType.update)),
      listener: (context, state) {
        if (state is CarDetailState && state.car != null) {
          context.read<CarFormCubit>().fillForm(state.car!);
        }
        if (state is CarManagementActionState && state.message != null) {
          final snackbarType = state.isError
              ? SnackBarType.error
              : SnackBarType.success;
          SnackBarUtils.show(
            context,
            message: context.tr(state.message!),
            type: snackbarType,
          );
          if (snackbarType == SnackBarType.success) {
            context.pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(_screenTitle())),
        body: BlocConsumer<CarFormCubit, CarFormState>(
          listener: (context, state) {
            if (state.sectionIndex != _pageController.page?.round()) {
              _goToSection(state.sectionIndex);
            }
          },
          builder: (context, state) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CarFormHeader(
                  title: context.tr(_sections[state.sectionIndex]['title']),
                  subtitle: context.tr(
                    _sections[state.sectionIndex]['subtitle'],
                  ),
                  icon: _sections[state.sectionIndex]['icon'],
                  sectionIndex: state.sectionIndex,
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      CarFormBasicSection(state: state),
                      CarFormLocationAndAvailabilitySection(state: state),
                      CarFormMediaAndDocumentsSection(
                        state: state,
                        onSubmit: (params) => _onSubmit(params),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

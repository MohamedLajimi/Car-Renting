import 'package:car_renting/core/app_status_bloc/app_status_bloc.dart';
import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:car_renting/core/widgets/custom_button.dart';
import 'package:car_renting/core/widgets/custom_indicator.dart';
import 'package:car_renting/features/auth/routes/auth_routes_names.dart';
import 'package:car_renting/features/auth/widgets/onboarding_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/onboarding_1.png',
      'title': 'auth.onboarding.title1',
      'description': 'auth.onboarding.desc1',
    },
    {
      'image': 'assets/images/onboarding_2.png',
      'title': 'auth.onboarding.title2',
      'description': 'auth.onboarding.desc2',
    },
    {
      'image': 'assets/images/onboarding_3.png',
      'title': 'auth.onboarding.title3',
      'description': 'auth.onboarding.desc3',
    },
  ];

  void _onPressButton() {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _finish() {
    context.read<AppStatusBloc>().add(OnboardingCompleted());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return BlocListener<AppStatusBloc, AppStatusState>(
      listener: (context, state) {
        if (state is AppStatusUnauthenticated) {
          context.goNamed(AuthRoutesNames.login);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
              onPressed: _finish,
              child: Text(
                context.tr('auth.onboarding.skip'),
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingData.length,
                    onPageChanged: (value) => setState(() {
                      _currentPage = value;
                    }),
                    itemBuilder: (context, index) => OnboardingWidget(
                      image: onboardingData[index]['image']!,
                      title: onboardingData[index]['title']!.tr(),
                      description: onboardingData[index]['description']!.tr(),
                    ),
                  ),
                ),
                CustomIndicator(
                  itemCount: onboardingData.length,
                  currentIndex: _currentPage,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: _currentPage == onboardingData.length - 1
                      ? context.tr('auth.onboarding.get_started')
                      : context.tr('auth.onboarding.next'),
                  onPressed: _onPressButton,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

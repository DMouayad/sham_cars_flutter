import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:sham_cars/features/common/future_cubit/future_cubit.dart';
import 'package:sham_cars/features/medical_entities/models.dart';
import 'package:sham_cars/features/medical_entities/medical_specialty_cubit.dart';
import 'package:sham_cars/features/medical_entities/repositories.dart';
import 'package:sham_cars/features/theme/app_theme.dart';
import 'package:sham_cars/utils/utils.dart';

class MedSpecialtiesSection extends StatelessWidget {
  const MedSpecialtiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MedicalSpecialtyCubit()..getSpecialties(),
      child: SizedBox(
        height: 100,
        child:
            BlocBuilder<MedicalSpecialtyCubit, FutureState<MedicalSpecialties>>(
              builder: (context, state) {
                return Skeletonizer(
                  ignoreContainers: false,
                  enabled: state.isLoading,
                  child: switch (state) {
                    ErrorFutureState<MedicalSpecialties>() => ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      title: Text(context.l10n.undefinedException),
                      leading: const Icon(Icons.error),
                      iconColor: AppTheme.redColor,
                      dense: true,
                      trailing: IconButton(
                        onPressed: context
                            .read<MedicalSpecialtyCubit>()
                            .getSpecialties,
                        icon: const Icon(Icons.refresh_outlined),
                      ),
                    ),
                    _ => ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => state.hasData
                          ? _Card(state.data!.items.elementAt(index))
                          : const _CardSkeleton(),
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 18),
                      itemCount: state.hasData ? state.data!.items.length : 5,
                    ),
                  },
                );
              },
            ),
      ),
    );
  }
}

class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton();

  @override
  Widget build(BuildContext context) {
    var borderRadius = BorderRadius.circular(6);
    return Skeletonizer.zone(
      child: Card(
        elevation: 0,
        child: Column(
          children: [
            Bone.square(size: 55, borderRadius: borderRadius),
            const SizedBox(height: 10),
            Bone.text(words: 1, borderRadius: borderRadius),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card(this.specialty);
  final MedicalSpecialty specialty;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Column(
        children: [
          Container(
            width: 55,
            height: 55,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xff4f94e5).withOpacity(.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: () {
              if (getSpecialtyImage(specialty.name) case String imgPath) {
                return SvgPicture.asset(imgPath);
              }
            }(),
          ),
          const SizedBox(height: 10),
          Text(
            getSpecialtyLocalizedName(specialty.name, context),
            textAlign: TextAlign.center,
            style: context.myTxtTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  String getSpecialtyLocalizedName(String specialty, BuildContext context) {
    return switch (specialty.toLowerCase()) {
      'cardiology' => context.l10n.cardiology,
      'neurology' => context.l10n.neurology,
      'dentistry' => context.l10n.dentistry,
      'prosthetics' => context.l10n.prosthetics,
      'ophthalmology' => context.l10n.ophthalmology,
      'family medicine' => context.l10n.familyMedicine,
      _ => specialty,
    };
  }

  String? getSpecialtyImage(String specialty) {
    return switch (specialty.toLowerCase()) {
      'cardiology' || 'dentistry' || 'neurology' || 'prosthetics' =>
        'assets/icons/med_specialties/${specialty.toLowerCase()}.svg',
      _ => null,
    };
  }
}

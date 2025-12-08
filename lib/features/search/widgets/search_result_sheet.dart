import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sham_cars/features/search/models/search_result.dart';
import 'package:sham_cars/features/theme/app_theme.dart';
import 'package:sham_cars/utils/utils.dart';

import 'search_result_card.dart';

class SearchResultSheet extends StatelessWidget {
  const SearchResultSheet({
    super.key,
    required this.result,
    required this.scrollController,
  });

  final SearchResult result;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(12, 15, 12, 0),
          child: Column(
            children: [
              Expanded(
                flex: 0,
                child: Column(
                  children: [
                    Hero(
                      tag: Key('search-result-${result.title}'),
                      child: SearchResultCardContent(
                        result,
                        showLocationAndRating: false,
                      ),
                    ),
                    _CustomTile(
                      result.location,
                      Icons.location_pin,
                      trailing: SizedBox(
                        width: 50,
                        child: Chip(
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: 3,
                          ),
                          shape: const RoundedRectangleBorder(
                            side: BorderSide(color: Colors.transparent),
                          ),
                          padding: EdgeInsets.zero,
                          avatar: const Icon(
                            Icons.star,
                            color: AppTheme.yellowColor,
                            size: 20,
                          ),
                          label: Text(
                            result.stars.toStringAsPrecision(1),
                            style: context.myTxtTheme.bodySmall,
                          ),
                        ),
                      ),
                    ),
                    if (_getPhoneNumbers() case String mobile)
                      _CustomTile(mobile, CupertinoIcons.phone),
                    _CustomTile(_getMobilePhoneNumbers(), CupertinoIcons.phone),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Text(
                        _getAbout(),
                        style: context.myTxtTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(context.l10n.openProfileBtnLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text _title(String text) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.bold));
  }

  String _getAbout() {
    return switch (result) {
      MedicalFacilitySearchResult facilityResult =>
        facilityResult.facility.description,
      PhysicianSearchResult physicianResult =>
        physicianResult.physician.biography,
    };
  }

  String _getAboutSectionTitle(BuildContext context) {
    return switch (result.category) {
      SearchResultCategory.physician => context.l10n.aboutDoctorSectionTitle,
      SearchResultCategory.facility => context.l10n.aboutFacilitySectionTitle,
    };
  }

  String? _getPhoneNumbers() {
    return switch (result) {
      MedicalFacilitySearchResult facilityResult =>
        facilityResult.facility.phoneNumber,
      PhysicianSearchResult physicianResult =>
        physicianResult.physician.phoneNumber,
    };
  }

  String _getMobilePhoneNumbers() {
    return switch (result) {
      MedicalFacilitySearchResult facilityResult =>
        facilityResult.facility.mobilePhoneNumber,
      PhysicianSearchResult physicianResult =>
        physicianResult.physician.mobilePhoneNumber,
    };
  }
}

class _CustomTile extends StatelessWidget {
  const _CustomTile(this.title, this.iconData, {this.trailing});
  final String title;
  final IconData iconData;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      iconColor: context.colorScheme.primary,
      leading: Icon(iconData),
      minTileHeight: 16,
      minLeadingWidth: 0,
      dense: true,
      title: Text(title),
      contentPadding: trailing != null
          ? const EdgeInsets.only(left: 6, right: 16)
          : null,
      trailing: trailing,
    );
  }
}

class _PhysicianShifts extends StatelessWidget {
  const _PhysicianShifts();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

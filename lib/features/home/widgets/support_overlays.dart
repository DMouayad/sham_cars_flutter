import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham_cars/features/support/models.dart';
import 'package:sham_cars/features/support/support_repository.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sham_cars/features/theme/constants.dart';
import 'package:sham_cars/utils/utils.dart';

class SupportOverlays {
  static Future<void> showFaq(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _FaqSheet(),
    );
  }

  static Future<void> showContact(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _ContactSheet(),
    );
  }
}

class _FaqSheet extends StatelessWidget {
  const _FaqSheet();

  @override
  Widget build(BuildContext context) {
    final repo = context.read<SupportRepository>();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      builder: (context, controller) {
        return FutureBuilder<AppSupport>(
          future: repo.getSupportInfo(),
          builder: (context, snap) {
            final loading = snap.connectionState != ConnectionState.done;

            return Skeletonizer(
              enabled: loading,
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(ThemeConstants.p),
                children: [
                  Text(
                    context.l10n.supportFaqSectionTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (snap.hasError && !loading)
                    Text(snap.error.toString())
                  else if (snap.data == null ||
                      (snap.data?.faq.isEmpty ?? true))
                    Text(context.l10n.supportFaqEmpty)
                  else ...[
                    for (final item in snap.data!.faq)
                      Card(
                        elevation: 0,
                        child: ExpansionTile(
                          title: Text(
                            item.question,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          childrenPadding: const EdgeInsetsDirectional.fromSTEB(
                            16,
                            0,
                            16,
                            16,
                          ),
                          children: [
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(item.answer),
                            ),
                          ],
                        ),
                      ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _ContactSheet extends StatelessWidget {
  const _ContactSheet();

  @override
  Widget build(BuildContext context) {
    final repo = context.read<SupportRepository>();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      builder: (context, controller) {
        return FutureBuilder<AppSupport>(
          future: repo.getSupportInfo(),
          builder: (context, snap) {
            final loading = snap.connectionState != ConnectionState.done;

            final data = snap.data;

            return Skeletonizer(
              enabled: loading,
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(ThemeConstants.p),
                children: [
                  Text(
                    context.l10n.supportContactSectionTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (snap.hasError && !loading)
                    Text(snap.error.toString())
                  else
                    Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            _contactRow(
                              context,
                              icon: Icons.phone_outlined,
                              label: context.l10n.supportPhoneLabel,
                              value: data?.contactPhone,
                              valueTextDirection: TextDirection.ltr,
                              onCopy: data?.contactPhone == null
                                  ? null
                                  : () => _copy(context, data!.contactPhone!),
                              onAction: data?.contactPhone == null
                                  ? null
                                  : () {
                                      launchUrl(
                                        Uri.parse(
                                          'tel:${data!.contactPhone!.replaceAll(' ', '')}',
                                        ),
                                      );
                                    },
                              actionIcon: Icons.call_rounded,
                              actionTooltip: context.l10n.supportCallAction,
                            ),
                            const Divider(height: 24),
                            _contactRow(
                              context,
                              icon: Icons.mail_outline_rounded,
                              label: context.l10n.supportEmailLabel,
                              value: data?.contactEmail,
                              valueTextDirection: TextDirection.ltr,
                              onCopy: data?.contactEmail == null
                                  ? null
                                  : () => _copy(context, data!.contactEmail!),
                              onAction: data?.contactEmail == null
                                  ? null
                                  : () {
                                      launchUrl(
                                        Uri.parse(
                                          'mailto:${data!.contactEmail!}',
                                        ),
                                      );
                                    },
                              actionIcon: Icons.send_rounded,
                              actionTooltip:
                                  context.l10n.supportSendEmailAction,
                            ),
                            const Divider(height: 24),
                            _contactRow(
                              context,
                              icon: Icons.location_on_outlined,
                              label: context.l10n.supportAddressLabel,
                              value: data?.contactAddress,
                              onCopy: data?.contactAddress == null
                                  ? null
                                  : () => _copy(context, data!.contactAddress!),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Widget _contactRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String? value,
    TextDirection? valueTextDirection,
    VoidCallback? onCopy,
    VoidCallback? onAction,
    IconData? actionIcon,
    String? actionTooltip,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: cs.onSurfaceVariant),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: cs.onSurfaceVariant)),
              const SizedBox(height: 4),
              Directionality(
                textDirection: valueTextDirection ?? Directionality.of(context),
                child: Text(
                  (value?.trim().isNotEmpty ?? false) ? value!.trim() : '—',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          tooltip: context.l10n.supportCopyAction,
          onPressed: onCopy,
          icon: Icon(
            Icons.copy_rounded,
            color: onCopy == null ? cs.outline : cs.primary,
          ),
        ),
        if (actionIcon != null)
          IconButton(
            tooltip: actionTooltip,
            onPressed: onAction,
            icon: Icon(
              actionIcon,
              color: onAction == null ? cs.outline : cs.primary,
            ),
          ),
      ],
    );
  }

  static Future<void> _copy(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.supportCopiedMessage)));
  }
}

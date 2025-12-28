// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:sham_cars/features/localization/cubit/localization_cubit.dart';
// import 'package:sham_cars/features/theme/theme_cubit.dart';
// import 'package:sham_cars/utils/utils.dart';

// class CustomScaffold extends StatelessWidget {
//   const CustomScaffold({
//     super.key,
//     this.loadingBarrierText,
//     this.bodyPadding,
//     this.appBarActions,
//     this.title,
//     this.showBackButton = true,
//     required this.showLoadingBarrier,
//     required this.body,
//     this.showOptionsActionBtn = true,
//   });
//   final String? loadingBarrierText;
//   final bool showLoadingBarrier;
//   final Widget body;
//   final EdgeInsets? bodyPadding;
//   final List<Widget>? appBarActions;
//   final String? title;
//   final bool showBackButton;
//   final bool showOptionsActionBtn;
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Scaffold(
//           backgroundColor: context.colorScheme.surface,
//           appBar: title != null || (context.canPop() && showBackButton)
//               ? AppBar(
//                   backgroundColor: context.colorScheme.surface,
//                   surfaceTintColor: context.colorScheme.surface,
//                   actions: [
//                     ...(appBarActions != null ? appBarActions! : []),
//                     if (showOptionsActionBtn)
//                       PopupMenuButton(
//                         itemBuilder: (context) => [
//                           PopupMenuItem(
//                             onTap: () => context.isDarkMode
//                                 ? context.read<ThemeCubit>().toggleLightMode()
//                                 : context.read<ThemeCubit>().toggleDarkMode(),
//                             child: Text(
//                               context.isDarkMode
//                                   ? context.l10n.disableDarkModeBtnLabel
//                                   : context.l10n.enableDarkModeBtnLabel,
//                             ),
//                           ),
//                           PopupMenuItem(
//                             onTap: context
//                                 .read<LocalizationCubit>()
//                                 .switchLocale,
//                             child: Text(
//                               context.getLocaleFullName(
//                                 context.isArabicLocale ? 'en' : 'ar',
//                               ),
//                             ),
//                           ),
//                           PopupMenuItem(
//                             child: Text(context.l10n.supportBtnLabel),
//                           ),
//                         ],
//                       ),
//                   ],
//                   title: title != null
//                       ? GradientText(
//                           title!,
//                           gradient: const LinearGradient(
//                             colors: [Color(0xFF4F94E5), Color(0xFF009D6D)],
//                           ),
//                           style: context.textTheme.titleMedium?.copyWith(
//                             fontWeight: FontWeight.w800,
//                           ),
//                         )
//                       : null,
//                   titleTextStyle: context.textTheme.titleMedium,
//                 )
//               : null,
//           body: SafeArea(
//             child: Padding(
//               padding: bodyPadding ?? const EdgeInsets.all(12),
//               child: body,
//             ),
//           ),
//         ),
//         Visibility(
//           visible: showLoadingBarrier,
//           child: SafeArea(child: _LoadingBarrier(text: loadingBarrierText)),
//         ),
//       ],
//     );
//   }
// }

// class _LoadingBarrier extends StatelessWidget {
//   const _LoadingBarrier({this.text});
//   final String? text;

//   @override
//   Widget build(BuildContext context) {
//     final textColor = context.isDarkMode
//         ? context.colorScheme.onSurface
//         : context.colorScheme.onInverseSurface;
//     return Material(
//       type: MaterialType.transparency,
//       child: Container(
//         color: context.isDarkMode
//             ? context.colorScheme.surface.withOpacity(.9)
//             : context.colorScheme.inverseSurface.withOpacity(.9),
//         child: GestureDetector(
//           child: Center(
//             child: SizedBox(
//               width: 250,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     text ?? context.l10n.loadingBarrierDefaultText,
//                     textAlign: TextAlign.center,
//                     style: context.myTxtTheme.titleLarge.copyWith(
//                       color: textColor,
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   CircularProgressIndicator(color: textColor),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

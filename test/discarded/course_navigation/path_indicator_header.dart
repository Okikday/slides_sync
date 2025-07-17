// import 'dart:ui';

// import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:iconsax_flutter/iconsax_flutter.dart';

// class PathIndicatorHeader extends ConsumerWidget {
//   final bool isDarkMode;
//   final List<String> paths;
//   final int? selectedItemsCount;
//   const PathIndicatorHeader({super.key, required this.isDarkMode, this.selectedItemsCount, this.paths = const []});

//   Widget pathWidget({String? title, required bool isCurrentPath}) {
//     return Row(
//       children: [
//         if (title == null || title.isEmpty)
//           Icon(
//             Iconsax.home,
//             size: 26,
//             color:
//                 paths.isEmpty
//                     ? isDarkMode
//                         ? Colors.white
//                         : Colors.black
//                     : Colors.grey,
//           ),
//         if (title != null && title.isNotEmpty) CustomText(title, color: isCurrentPath ? null : Colors.grey),
//         Icon(
//           Icons.keyboard_arrow_right,
//           color:
//               isCurrentPath
//                   ? isDarkMode
//                       ? Colors.white
//                       : Colors.black
//                   : Colors.grey,
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return ClipRRect(
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 4, sigmaY: 6),
//         child: SizedBox(
//           height: 40,
//           child: Stack(
//             alignment: Alignment.center,
//             clipBehavior: Clip.hardEdge,
//             children: [
//               Positioned(
//                 height: 40,
//                 left: 0,
//                 right: 0,
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: ListView(
//                         scrollDirection: Axis.horizontal,
//                         padding: EdgeInsets.symmetric(horizontal: 16.0),
//                         children: List.generate(paths.length + 1, (index) {
//                           if (index == 0) return pathWidget(isCurrentPath: false);
//                           return pathWidget(title: paths[index - 1], isCurrentPath: paths.last == paths[index - 1]);
//                         }),
//                       ).animate().fade(begin: selectedItemsCount == null ? .25 : 1, end: selectedItemsCount == null ? 1 : .25),
//                     ),
//                     if (selectedItemsCount != null)
//                       CustomElevatedButton(
//                         borderRadius: 0,
//                         backgroundColor: Colors.red.withValues(alpha: .75),
//                         shape: CircleBorder(),
//                         contentPadding: EdgeInsets.all(8.0),
//                         child: Icon(Icons.cancel_outlined),
//                       ).animate().slideX(begin: 1, duration: Durations.extralong4, curve: CustomCurves.bouncySpring).fadeIn(),
//                     ConstantSizing.rowSpacingMedium,
//                   ],
//                 ),
//               ),

//               if (selectedItemsCount != null)
//                 Positioned(
//                   child:
//                       Container(
//                         padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                         clipBehavior: Clip.hardEdge,
//                         decoration: BoxDecoration(
//                           color: context.theme.primaryColor.withValues(alpha: .75),
//                           border: Border.fromBorderSide(BorderSide(color: context.theme.secondary.withAlpha(20))),
//                           borderRadius: BorderRadius.circular(24),
//                         ),
//                         child: BackdropFilter(
//                           filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             spacing: 4.0,
//                             children: [
//                               Icon(Iconsax.check, size: 18, color: context.theme.secondary.withAlpha(80)),
//                               CustomText('$selectedItemsCount items selected!'),
//                             ],
//                           ),
//                         ),
//                       ).animate().slideY(begin: -1, curve: CustomCurves.bouncySpring, duration: Durations.extralong4).fadeIn(),
//                 ),

//               if (selectedItemsCount == null)
//                 Positioned(
//                   right: 16,
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       CustomElevatedButton(
//                         shape: CircleBorder(),
//                         backgroundColor: Colors.white.withValues(alpha: 0.1),
//                         child: Icon(Iconsax.arrow_up, color: isDarkMode ? Colors.white : Colors.black),
//                         onClick: () {},
//                       ),
//                       CustomElevatedButton(
//                         shape: CircleBorder(),
//                         backgroundColor: context.theme.secondary.withValues(alpha: 0.5),
//                         child: Icon(Iconsax.add_circle),
//                         onClick: () {},
//                       ),
//                     ],
//                   ).animate().slideY(begin: -1, duration: Durations.extralong4, curve: CustomCurves.bouncySpring),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

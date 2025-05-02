import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app/states/app_ui_state.dart';
import 'package:slides_sync/use_cases/library/library_ui_funcs.dart';

class CourseMaterialCard extends ConsumerWidget {

  final CourseMaterialCardModel courseMaterialCardModel;
  const CourseMaterialCard(this.appUiStateProvider, {
    super.key,
    required this.courseMaterialCardModel,
  });

  final NotifierProvider<AppUiState, AppUiModel> appUiStateProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppUiModel appUiModel = ref.watch(appUiStateProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(

        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: LibraryUiFuncs.getBoxDecorationStyle(appUiModel.isDarkMode),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               courseMaterialCardModel.previewImage == null ? Container(width: appUiModel.deviceWidth * 0.2, height: appUiModel.deviceWidth * 0.2, decoration: BoxDecoration(color: Colors.deepPurple.withAlpha(40), borderRadius: BorderRadius.circular(8.0)), child: Icon(Iconsax.book_1_copy),) :
               Container(color: Colors.deepPurple.withAlpha(40), width: appUiModel.deviceWidth * 0.2, height: appUiModel.deviceWidth * 0.2, child: courseMaterialCardModel.previewImage,),
                ConstantSizing.rowSpacingMedium,
                Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(courseMaterialCardModel.title, fontSize: 13,),
                        ConstantSizing.columnSpacingMedium,
                        LinearProgressIndicator(
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(36),
                          value: courseMaterialCardModel.progress,
                          backgroundColor: Colors.black.withAlpha(40),
                          color: Colors.deepPurple, //.withAlpha(40)
                        ),
                      ],
                    )),
                ConstantSizing.rowSpacingMedium,
                IconButton(onPressed: (){},
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.lightBlueAccent.withAlpha(20))
                    ),
                    icon: Icon(Icons.keyboard_arrow_down, size: 28,))
              ],
            ),

           if(courseMaterialCardModel.isMenuExpanded) ConstantSizing.columnSpacingMedium,

            if(courseMaterialCardModel.isMenuExpanded) Padding(
              padding: EdgeInsets.only(left: appUiModel.deviceWidth * 0.2 + ConstantSizing.rowSpacingMedium.width!),
              child: Builder(

                builder: (context) {
                  final List<CourseMaterialCardFunctionsModel> cardsList = courseMaterialCardModel.courseMaterialCardFunctionsModels;
                  final List<Widget> genCardFuncs = List.generate(cardsList.length, (index){
                    return CustomElevatedButton(
                      borderRadius: 24,
                      backgroundColor: Colors.deepPurple.withAlpha(40),
                      onClick: cardsList[index].onTap,
                      child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(cardsList[index].icon),
                        ConstantSizing.rowSpacingSmall,
                        CustomText(cardsList[index].label,),
                      ],
                    ),);
                  });
                  return Wrap(
                    runAlignment: WrapAlignment.start,
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: genCardFuncs,
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}


class CourseMaterialCardModel{
  final String title;
  final double progress;
  final Widget? previewImage;
  final bool isMenuExpanded;
  final void Function()? onOpen;
  final List<CourseMaterialCardFunctionsModel> courseMaterialCardFunctionsModels;

  CourseMaterialCardModel({required this.title, required this.progress, this.previewImage, required this.isMenuExpanded, this.onOpen, required this.courseMaterialCardFunctionsModels});

  CourseMaterialCardModel copyWith({
    String? title,
    double? progress,
    Widget? previewImage,
    bool? isMenuExpanded,
    void Function()? onOpen,
    List<CourseMaterialCardFunctionsModel>? courseMaterialCardFunctionsModels,
  }) {
    return CourseMaterialCardModel(
      title: title ?? this.title,
      progress: progress ?? this.progress,
      previewImage: previewImage ?? this.previewImage,
      isMenuExpanded: isMenuExpanded ?? this.isMenuExpanded,
      onOpen: onOpen ?? this.onOpen,
      courseMaterialCardFunctionsModels: courseMaterialCardFunctionsModels ?? this.courseMaterialCardFunctionsModels,
    );
  }

}

class CourseMaterialCardFunctionsModel{
  final String label;
  final IconData icon;
  final void Function() onTap;

  CourseMaterialCardFunctionsModel({required this.label, required this.icon, required this.onTap});

  CourseMaterialCardFunctionsModel copyWith({
    String? label,
    IconData? icon,
    void Function()? onTap,
  }) {
    return CourseMaterialCardFunctionsModel(
      label: label ?? this.label,
      icon: icon ?? this.icon,
      onTap: onTap ?? this.onTap,
    );
  }

}

import 'package:flutter/widgets.dart';

class CourseMaterialCardModel {
  final String title;
  final double progress;
  final Widget? previewImage;
  final void Function()? onOpen;
  final List<CourseMaterialCardFunctionsModel> courseMaterialCardFunctionsModels;

  CourseMaterialCardModel({
    required this.title,
    required this.progress,
    this.previewImage,
    this.onOpen,
    required this.courseMaterialCardFunctionsModels,
  });

  CourseMaterialCardModel copyWith({
    String? title,
    double? progress,
    Widget? previewImage,
    void Function()? onOpen,
    List<CourseMaterialCardFunctionsModel>? courseMaterialCardFunctionsModels,
  }) {
    return CourseMaterialCardModel(
      title: title ?? this.title,
      progress: progress ?? this.progress,
      previewImage: previewImage ?? this.previewImage,
      onOpen: onOpen ?? this.onOpen,
      courseMaterialCardFunctionsModels: courseMaterialCardFunctionsModels ?? this.courseMaterialCardFunctionsModels,
    );
  }
}


class CourseMaterialCardFunctionsModel {
  final String label;
  final IconData icon;
  final void Function() onTap;

  CourseMaterialCardFunctionsModel({required this.label, required this.icon, required this.onTap});

  CourseMaterialCardFunctionsModel copyWith({String? label, IconData? icon, void Function()? onTap}) {
    return CourseMaterialCardFunctionsModel(label: label ?? this.label, icon: icon ?? this.icon, onTap: onTap ?? this.onTap);
  }
}
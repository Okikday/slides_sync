class IconStrings {
  static final IconStrings instance = IconStrings._instance();
  IconStrings._instance();

  static const String _iconPrefix = "assets/icons/";
  static const String _animIconPrefix = "assets/icons/animated_jsons/";

  static String _withIconPrefix(String name) => "$_iconPrefix$name";
  static String _withAnimIconPrefix(String name) => "$_animIconPrefix$name";

  String get addCardAnim => _withAnimIconPrefix("system-regular-40-add-card-hover-add-card.json");
  String get addFolderAnim => _withAnimIconPrefix("add_folder_anim.json");



}

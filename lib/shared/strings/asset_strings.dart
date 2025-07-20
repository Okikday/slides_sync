class AssetStrings {
  static final AssetStrings instance = AssetStrings._instance();
  AssetStrings._instance();

  static const String _imagePrefix = "assets/images/";
  static String _withImagePrefix(String name) => "$_imagePrefix$name";

  String get bookSparkleTransparentBg => _withImagePrefix("book_sparkle_bg.png");
}

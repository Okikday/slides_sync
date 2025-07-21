class AssetStrings {
  static final AssetStrings instance = AssetStrings._instance();
  AssetStrings._instance();

  static const String _imagePrefix = "assets/images/";
  static String _withImagePrefix(String name) => "$_imagePrefix$name";

  String get bookSparkleTransparentBg => _withImagePrefix("book_sparkle_bg.png");
  String get zigzagWavy => _withImagePrefix("zig_zag_wavy.png");
  String get eduElements => _withImagePrefix("edu_elements.png");
}

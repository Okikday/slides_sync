class ImageStrings {
  static final ImageStrings instance = ImageStrings._instance();
  ImageStrings._instance();

  static const String _imagePrefix = "assets/images/";
  static String _withImagePrefix(String name) => "$_imagePrefix$name";

  String get bookSparkleTransparentBg => _withImagePrefix("book_sparkle_bg.png");
  String get zigzagWavy => _withImagePrefix("zig_zag_wavy.png");
  String get eduElements => _withImagePrefix("edu_elements.png");

  // Welcome screen
  String get welcomeImage => _withImagePrefix("welcome_view_image.png");
  String get welcomeImageTop => _withImagePrefix("welcome_view_image_top.png");
  String get welcomeImageBottom => _withImagePrefix("welcome_view_image_bottom.png");
  String get clouds => _withImagePrefix("clouds.png");

  // Onboaring Screens
  String get onboarding1 => _withImagePrefix("onboarding_1.png");

  // Sign in screen
  String get signInViewBg => _withImagePrefix("sign_in_view_bg.png");

  String get wpImage1 => _withImagePrefix("bg_1.jpg");
}

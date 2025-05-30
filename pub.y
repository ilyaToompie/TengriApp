name: lms_app
description: A new Flutter project.
publish_to: 'none'

version: 1.1.4+15

environment:
  sdk: '>=3.1.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.6
  url_launcher: ^6.2.5
  firebase_core: ^2.27.1
  firebase_auth: ^4.17.9
  cloud_firestore: ^4.15.9
  shared_preferences: ^2.2.2
  fluttertoast: ^8.2.4
  firebase_messaging: ^14.7.20
  flutter_rating_bar: ^4.0.1
  pod_player: ^0.2.1
  crypto: ^3.0.3
  flutter_html: ^3.0.0-beta.2
  easy_localization: ^3.0.5
  hive_flutter: ^1.1.0
  salomon_bottom_bar: ^3.3.2
  flutter_riverpod: ^2.5.1
  carousel_slider: ^5.0.0
  google_fonts: ^6.2.1
  line_icons: ^2.0.3
  feather_icons: ^1.2.0
  cached_network_image: ^3.3.1
  simple_animations: ^5.0.2
  font_awesome_flutter: ^10.7.0
  in_app_purchase: ^3.1.13
  in_app_purchase_android: ^0.3.2
  in_app_purchase_platform_interface: ^1.3.7
  in_app_purchase_storekit: ^0.3.13+1
  flutter_web_browser: ^0.17.1
  quiver: ^3.2.1
  percent_indicator: ^4.2.3
  flutter_svg: ^2.0.10+1
  image_picker: ^1.0.7
  firebase_storage: ^11.6.10
  material_dialogs: ^1.1.4
  path_provider: ^2.1.2
  app_settings: ^5.1.1
  loading_indicator: ^3.1.1
  smooth_page_indicator: ^1.1.0
  shimmer: ^3.0.0
  html_unescape: ^2.0.0
  share_plus: ^8.0.2
  firebase_analytics: ^10.8.10
  rounded_loading_button:
    git:
      url: https://github.com/scopendo/flutter_rounded_loading_button.git
      ref: master
  screen_protector: ^1.4.2
  file_picker: ^8.0.6
  super_editor: ^0.3.0-dev.2
  mime: ^1.0.5


  lottie: any
  html: any
  rename_app: ^1.6.1
  secure_content: ^0.1.0
dev_dependencies:
  flutter_test:
    sdk: flutter

  flutter_lints: ^3.0.1
  change_app_package_name: ^1.1.0
  flutter_launcher_icons: ^0.13.1


flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icon/icon.png"
  min_sdk_android: 21
  super_editor: ^0.2.7



flutter:
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  assets:
   - assets/animations/
   - assets/images/
   - assets/translations/
        


    

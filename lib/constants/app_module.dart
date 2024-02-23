import 'package:toughest_new/main.dart';
import 'package:toughest_new/utilities/progress_dialog_utils.dart';

import 'AdsManager/ad_services.dart';

void setUp() {
  getIt.registerSingleton<AdService>(AdService());
  getIt.registerSingleton<CustomDialogs>(CustomDialogs());
}
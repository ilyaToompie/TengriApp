import 'package:lms_app/utils/toasts.dart';
import 'package:screen_protector/screen_protector.dart';


class ContentSecurityService {
  initContentSecurity() { //WidgetRef ref
      _preventScreenshotOn();
      _checkScreenRecording();
  }

  disposeContentSecurity() {
    _preventScreenshotOff();
  }

  void _checkScreenRecording() async {
    final isRecording = await ScreenProtector.isRecording();
    if (isRecording) {
      openToast('Screen recording......');
    }
  }

  void _preventScreenshotOn() async => await ScreenProtector.protectDataLeakageWithBlur();

  void _preventScreenshotOff() async => await ScreenProtector.protectDataLeakageWithBlurOff();

}

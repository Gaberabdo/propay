

import '../../../utils/app_constants.dart';

class OnBordingData {
  String imagePath;
  String title;
  String description;

  OnBordingData(
      {required this.imagePath,
      required this.title,
      required this.description});
}

List<OnBordingData> onBordingDataList = [
  OnBordingData(
      imagePath: "$rootImageDir/onbording_1.png",
      title: "شحن الألعاب بسهولة",
      description:
      "استمتع بخدمة شحن الألعاب الخاصة بك بكل سهولة وسرعة. سواء كنت تحتاج لشحن رصيد ألعابك أو دفع فواتير أخرى، لدينا الحل المناسب لك."),
  OnBordingData(
      imagePath: "$rootImageDir/onbording_2.png",
      title: "شحن رصيدك بسرعة",
      description:
      "قم بشحن رصيدك بسهولة وبدون عناء. نحن نقدم لك خدمات شحن متنوعة تشمل الألعاب، الرصيد، والمزيد، لضمان تجربة مريحة وسلسة."),
  OnBordingData(
      imagePath: "$rootImageDir/onbording_3.png",
      title: "دفع فواتيرك بكل سهولة",
      description:
      "ادفع فواتير المياه، الكهرباء، والإنترنت من خلال تطبيقنا بكل سهولة. نحن هنا لتسهيل عملية الدفع وضمان راحتك."),
];

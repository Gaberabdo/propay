import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Gamers-Arena';

  //BASE_URL
  static const String baseUrl = 'https://sw-games.net/api';



  ///todo endpoit
  static const String allGamesUrl = '/games';









  //END_POINTS_URL
  static const String registerUrl = '/register';
  static const String loginUrl = '/login';
  static const String forgotPassUrl = '/recovery-pass/get-email';
  static const String forgotPassGetCodeUrl = '/recovery-pass/get-code';
  static const String updatePassUrl = '/update-pass';
  static const String appConfigUrl = '/app/config';
  static const String languageUrl = '/language';
  static const String profileUrl = '/users/info';
  static const String profileUpdateUrl = '/profile/information/update';
  static const String profileImageUploadUrl = '/profile/image/upload';
  static const String profilePassUpdateUrl = '/profile/password/update';
  static const String addressVerificationUrl =
      '/profile/address-verification/submit';
  static const String identityVerificationUrl =
      '/profile/identity-verification/submit';
  static const String twoFaSecurityUrl = '/2FA-security';
  static const String twoFaSecurityEnableUrl = '/2FA-security/enable';
  static const String twoFaSecurityDisableUrl = '/2FA-security/disable';
  static const String mailUrl = '/mail-verify';
  static const String smsVerifyUrl = '/sms-verify';
  static const String towFaVerifyUrl = '/twoFA-Verify';
  static const String resendCodeUrl = '/resend-code';
  //----------------SHOP MODULE---------------
  static const String shopListUrl = '/shop/list';
  static const String topupDetailsUrl = '/topUp/details';
  static const String voucherDetailsUrl = '/voucher/details';
  static const String giftCardDetailsUrl = '/gift-card/details';
  static const String topupPaymentUrl = '/top-up/payment';
  static const String voucherPaymentUrl = '/voucher/payment';
  static const String giftCardPaymentUrl = '/gift-card/payment';
  static const String manualPaymentUrl = '/manual-payment';
  static const String otherPaymentUrl = '/show-other-payment';
  static const String walletPaymentUrl = '/wallet-payment';
  static const String cardPaymentUrl = '/card-payment';
  static const String onPaymentDoneUrl = '/payment-done';
  //------------
  static const String transactionUrl = '/transaction/search';
  static const String paymentLogUrl = '/payment-log/search';
  static const String withdrawLogUrl = '/payout-history/search';
  static const String topupOrderUrl = '/topUp/order';
  static const String voucherOrderUrl = '/voucher/order';
  static const String giftCardOrderUrl = '/giftCard/order';
  static const String idPurchaseUrl = '/id/purchases';
  static const String myOfferUrl = '/my/offer';
  static const String myOfferDetailsUrl = '/buy/id/details';
  //----support ticket
  static const String supportTicketListUrl = '/support-ticket/list';
  static const String supportTicketCreateUrl = '/support-ticket/create';
  static const String supportTicketReplyUrl = '/support-ticket/reply';
  static const String supportTicketViewUrl = '/support-ticket/view';
  //-----my sales
  static const String sellPostListUrl = "/sell-post/list";
  static const String sellPostCategoryUrl = "/sell-post/category";
  static const String createPostUrl = "/sell-post/create";
  static const String editPostUrl = "/sell-post/edit";
  static const String updatePostUrl = "/sell-post/update";
  static const String sellPostDeleteUrl = "/sell-post/delete";
  //
  static const String buyIdUrl = "/buy/id";
  static const String makeOfferUrl = "/make/offer";
  static const String buyIdMakePayment = "/buy/id/make-payment";
  static const String gatewaysUrl = "/get/gateways";
  //-----conversation
  static const String offerListUrl = "/offer/list";
  static const String conversationUrl = "/offer/conversation";
  static const String newMessageUrl = "/offer/new-message";
  static const String offerLockUrl = "/offer/payment-lock";
  static const String offerAcceptUrl = "/offer/accept";
  static const String offerRejectUrl = "/offer/reject";
  static const String offerRemoveUrl = "/offer/remove";
  //-----pusher config
  static const String pusherConfigUrl = "/pusher/config";
  //-----Withdraw
  static const String payoutUrl = "/payout";
  static const String payoutSubmitUrl = "/payout/submit/confirm";
  static const String getBankFromBankUrl = "/payout/get-bank/from";
  static const String getBankFromCurrencyUrl = "/payout/get-bank/list";
  static const String flutterwaveSubmitUrl = "/payout/flutterwave/submit";
  static const String paystackSubmitUrl = "/payout/paystack/submit";

  static const String dashboardUrl = "/dashboard";
}

//----------IMAGE DIRECTORY---------//
String rootImageDir = "assets/images";
String rootIconDir = "assets/icons";
String rootJsonDir = "assets/json";


void navigateToScreen(
    BuildContext context,
    Widget widget,
    ) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ),
  );
}

 class PHPENDPOINT {
   //BASE_URL_PHP
   static const String baseUrlPHP = 'http://dam.fawatiri.sy/api';


   ///cat image
   static const String catImage = 'https://dam.fawatiri.sy/admin/files/cat/';
   static const String sliderImage = 'https://dam.fawatiri.sy/admin/files/images/slider/';
   static const String subCatImage = 'https://dam.fawatiri.sy/admin/files/subcat/';
   ///Auth
   static const String loginEndPoint = '/login.php';
   static const String registerEndPoint = '/register.php';
   static const String userInfoEndPoint = '/user_info.php';
   static const String userUpdateInfoEndPoint = '/user_update.php';


   ///Home
   static const String userTransactionEndPoint = '/get_user_orders.php';
   static const String allCate = '/cat.php';
   static const String allSubCate = '/subcat.php';
   static const String subcat_content = '/subcat_content.php';
   static const String searchCenters = '/searchCenters.php';
   static const String photoCarusel = '/photoCarusel.php';
   static const String create_my_offer = '/set_user_order.php';
   static const String chargeAccount = '/charge.php';
}
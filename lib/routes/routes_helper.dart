import 'package:flutter/material.dart';
import 'package:gamers_arena/routes/page_index.dart';
import 'package:gamers_arena/views/screens/profile/accredited_screen.dart';
import 'routes_name.dart';

class RouteHelper {
  static List<GetPage> routes() => [
        GetPage(
            name: RoutesName.initial,
            page: () => SplashScreen(),
            transition: Transition.zoom),
        GetPage(
            name: RoutesName.onbordingScreen,
            page: () => OnbordingScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.bottomNavBar,
            page: () => BottomNavBar(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.chargingAccount,
            page: () => ChargingScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.homeScreen,
            page: () => HomeScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.loginScreen,
            page: () => LoginScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.signUpScreen,
            page: () => SignUpScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.forgotPassScreen,
            page: () => ForgotPassScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.otpScreen,
            page: () => OtpScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.createNewPassScreen,
            page: () => CreateNewPassScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.profileSettingScreen,
            page: () => ProfileSettingScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.editProfileScreen,
            page: () => EditProfileScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.changePasswordScreen,
            page: () => ChangePasswordScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.transactionScreen,
            page: () => TransactionScreen(),
            transition: Transition.fade),

        GetPage(
            name: RoutesName.createSupportTicketScreen,
            page: () => CreateSupportTicketScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.supportTicketListScreen,
            page: () => SupportTicketListScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.accreditedListScreen,
            page: () => AccreditedScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.supportTicketViewScreen,
            page: () => SupportTicketViewScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.twoFaVerificationScreen,
            page: () => TwoFaVerificationScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.notificationScreen,
            page: () => NotificationScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.idPurchaseScreen,
            page: () => IdPurchaseScreen(),
            transition: Transition.fade),




        GetPage(
            name: RoutesName.addressVerificationScreen,
            page: () => AddressVerificationScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.identityVerificationScreen,
            page: () => IdentityVerificationScreen(),
            transition: Transition.fade),

        GetPage(
            name: RoutesName.topupOrderScreen,
            page: () => TopupOrderScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.voucherOrderScreen,
            page: () => VoucherOrderScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.giftCardOrderScreen,
            page: () => GiftCardOrderScreen(FilterName: ''),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.myOfferScreen,
            page: () => Scaffold(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.myOfferDetailsScreen,
            page: () => MyOfferDetailsScreen(id: ''),
            transition: Transition.fade),

        GetPage(
            name: RoutesName.paymentSuccessScreen,
            page: () => PaymentSuccessScreen(),
            transition: Transition.fade),

        GetPage(
            name: RoutesName.conversationListScreen,
            page: () => ConversationListScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.inboxScreen,
            page: () => InboxScreen(),
            transition: Transition.fade),

        GetPage(
            name: RoutesName.verficiationCheckScreen,
            page: () => VerficiationCheckScreen(verficationType: 'Email'),
            transition: Transition.fade),
      ];
}

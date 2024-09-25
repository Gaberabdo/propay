import 'package:gamers_arena/controllers/bindings/controller_index.dart';
import 'package:get/get.dart';
import '../my_offer_controller.dart';
import '../create_post_controller.dart';
import '../edit_post_controller.dart';

class InitBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(AppController());
    Get.put(PushNotificationController());
    Get.put(ProfileController());

    Get.lazyPut<ConversationController>(() => ConversationController(),
        fenix: true);


    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<BottomNavController>(() => BottomNavController(), fenix: true);
    Get.lazyPut<VerificationController>(() => VerificationController(),
        fenix: true);
    Get.lazyPut<TransactionController>(() => TransactionController(),
        fenix: true);
    Get.lazyPut<PaymentLogController>(() => PaymentLogController(),
        fenix: true);
    Get.lazyPut<WithdrawLogController>(() => WithdrawLogController(),
        fenix: true);
    Get.lazyPut<TopupOrderController>(() => TopupOrderController(),
        fenix: true);
    Get.lazyPut<VoucherOrderController>(() => VoucherOrderController(),
        fenix: true);
    Get.lazyPut<GiftCardOrderController>(() => GiftCardOrderController(''),
        fenix: true);
    Get.lazyPut<IdPurchaseController>(() => IdPurchaseController(),
        fenix: true);
    Get.lazyPut<MyOfferController>(() => MyOfferController(), fenix: true);
    Get.lazyPut<SupportTicketController>(() => SupportTicketController(),
        fenix: true);
    Get.lazyPut<SellPostListController>(() => SellPostListController(),
        fenix: true);
    Get.lazyPut<CreatePostController>(() => CreatePostController(),
        fenix: true);
    Get.lazyPut<EditPostController>(() => EditPostController(), fenix: true);
    Get.lazyPut<BuyIdController>(() => BuyIdController(), fenix: true);
    Get.lazyPut<AddFundController>(() => AddFundController(), fenix: true);
    Get.lazyPut<WithdrawController>(() => WithdrawController(), fenix: true);
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
  }
}

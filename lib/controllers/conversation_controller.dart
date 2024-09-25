import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gamers_arena/utils/services/helpers.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../data/models/conversation_model.dart';
import '../data/repositories/conversation_repo.dart';
import '../data/models/offer_list_model.dart' as offer;
import '../data/repositories/notification_repo.dart';
import '../data/source/check_status.dart';

class ConversationController extends GetxController {
  static ConversationController get to => Get.find<ConversationController>();
  late ScrollController scrollController;
  TextEditingController searchEditingCtrl = TextEditingController();
  TextEditingController dateTimeEditingCtrl = TextEditingController();
  var selectedVal = null;
  String sortBy = "";
  int _page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<offer.Data> offerList = [];
  List<offer.Data> searchedConversationList = [];
  Future loadMore() async {
    if (_isLoading == false &&
        isLoadMore == false &&
        hasNextPage == true &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      Helpers.hideKeyboard();
      update();
      _page += 1;
      await getConversationList(
          page: _page,
          dateTime: dateTimeEditingCtrl.text,
          sortBy: sortBy,
          isLoadMoreRunning: true);
      if (kDebugMode) {
        print("====================loaded from load more: " + _page.toString());
      }
      isLoadMore = false;
      update();
    }
  }

  bool isSearchTapped = false;
  resetDataAfterSearching({bool? isFromOnRefreshIndicator = false}) {
    offerList.clear();
    isSearchTapped = true;
    hasNextPage = true;
    _page = 1;
    update();
  }

  Future getConversationList(
      {required int page,
      required String dateTime,
      required String sortBy,
      bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response = await ConversationRepo.getConversationList(
        page: page, dateTime: dateTime, sortBy: sortBy);
    if (isLoadMoreRunning == false) {
      _isLoading = false;
    }
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final fetchedData = data['message']['sellPostOffer']['data'];
        if (fetchedData.isNotEmpty) {
          offerList.addAll(offer.OfferListModel.fromJson(data)
              .message!
              .sellPostOffer!
              .data!);
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          if (kDebugMode) {
            print("================isDataEmpty: false");
            print("================ticket list len: " +
                offerList.length.toString());
          }
          update();
        } else {
          offerList.addAll(offer.OfferListModel.fromJson(data)
              .message!
              .sellPostOffer!
              .data!);
          hasNextPage = false;
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          if (kDebugMode) {
            print("================isDataEmpty: true");
          }

          update();
        }
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      offerList = [];
    }
  }

  bool isSearching = false;
  querytitle(String v) {
    searchedConversationList = offerList
        .where((e) =>
            e.description.toString().toLowerCase().contains(v.toLowerCase()))
        .toList();
    if (v.isEmpty) {
      isSearching = false;
      searchedConversationList.clear();
      update();
    } else if (v.isNotEmpty) {
      isSearching = true;
      update();
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getConversationList(page: _page, dateTime: "", sortBy: "");
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    _isLoading = false;
    offerList.clear();
  }

  bool isOfferLocking = false;
  TextEditingController offerAmountCtrl = TextEditingController();
  Future offerLock({required Map<String, String> fields}) async {
    isOfferLocking = true;
    update();
    http.Response response = await ConversationRepo.offerLock(fields: fields);
    isOfferLocking = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        offerAmountCtrl.clear();
        update();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data}');
    }
  }

  TextEditingController offerAcceptCtrl = TextEditingController();
  bool isAccepting = false;
  Future offerAccept(
      {required Map<String, String> fields,
      required BuildContext context}) async {
    isAccepting = true;
    update();
    http.Response response = await ConversationRepo.offerAccept(fields: fields);
    isAccepting = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        resetDataAfterSearching();
        getConversationList(page: 1, dateTime: "", sortBy: "");
        offerAcceptCtrl.clear();
        Navigator.pop(context);
        update();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data}');
    }
  }

  Future offerReject({required Map<String, String> fields}) async {
    http.Response response = await ConversationRepo.offerReject(fields: fields);
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        resetDataAfterSearching();
        getConversationList(page: 1, dateTime: "", sortBy: "");
        update();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data}');
    }
  }

  Future offerRemove({required Map<String, String> fields}) async {
    http.Response response = await ConversationRepo.offerRemove(fields: fields);
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        resetDataAfterSearching();
        getConversationList(page: 1, dateTime: "", sortBy: "");
        update();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data}');
    }
  }

  //=====================GET CONVERSATION INBOX===============
  TextEditingController messageEditingCtrl = TextEditingController();
  bool isCreatingNewMessage = false;
  Future createNewMessage({required Map<String, String> fields}) async {
    isCreatingNewMessage = true;
    update();
    http.Response response =
        await ConversationRepo.createNewMessage(fields: fields);
    isCreatingNewMessage = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        // getConversation(uuid: this.uuid, isFromInboxPage: true);
        messageEditingCtrl.clear();
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data}');
    }
  }

  bool isGettingConv = false;
  List<SiteNotification> reversedConversationList = [];
  List<SiteNotification> conversationList = [];
  bool timeVisible = false;
  int selectedIndex = -1;
  String uuid = "";
  int loginUserId = 1;
  Future getConversation(
      {required String uuid, bool? isFromInboxPage = false}) async {
    if (isFromInboxPage == false) {
      isGettingConv = true;
      update();
    }
    http.Response response = await ConversationRepo.getConversation(uuid: uuid);
    if (isFromInboxPage == false) {
      isGettingConv = false;
      update();
    }
    reversedConversationList = [];
    conversationList = [];
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        loginUserId = data['message']['loginUserId'];
        conversationList.addAll(
            ConversationListModel.fromJson(data).message!.siteNotifications!);
        reversedConversationList = List.from(conversationList.reversed);
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      reversedConversationList = [];
    }
  }

  dynamic data;
  Future<dynamic> getChattingConfig() async {
    http.Response res = await NotificationRepo.getPusherConfig();

    if (res.statusCode == 200) {
      data = jsonDecode(res.body);
      update();
      if (data['status'] == "success") {
        PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
        String channel = data['message']['chattingChannel'].toString();
        String chattingChannel = channel.substring(0, channel.indexOf('.'));
        try {
          await pusher.init(
            apiKey: data['message']['apiKey'],
            cluster: data['message']['cluster'],
            onConnectionStateChange: onConnectionStateChange,
            onSubscriptionSucceeded: onSubscriptionSucceeded,
            onEvent: onEvent,
            onSubscriptionError: onSubscriptionError,
            onMemberAdded: onMemberAdded,
            onMemberRemoved: onMemberRemoved,
          );
          await pusher.subscribe(
              channelName: chattingChannel + ".${this.uuid}");
          await pusher.connect();
        } catch (e) {
          print("ERROR====================================: $e");
        }

        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      _isLoading = false;
      update();
    }
  }

  void onError(String message, int? code, dynamic e) {
    print("onError: $message code: $code exception: $e");
  }

  void onEvent(PusherEvent event) async {
    if (kDebugMode) {
      print("onEvent: ${event.data}");
    }
    if (event.data != null) {
      // Parse the JSON response
      final eventData = jsonDecode(event.data);
      if (kDebugMode) {
        // print(eventData);
      }
      var json = eventData['message'];
      var chattable = json['chatable'];
      reversedConversationList.insert(
          0,
          SiteNotification(
            id: json["id"],
            sellPostId: 0,
            offerId: 0,
            chatableType: json["chatable_type"],
            chatableId: json["chatable_id"],
            description: json["description"],
            isRead: json["is_read"],
            isReadAdmin: json["is_read_admin"],
            createdAt: DateTime.parse(json["created_at"]),
            updatedAt: DateTime.parse(json["updated_at"]),
            formattedDate: json["formatted_date"],
            chatable: Chatable(
              id: chattable["id"],
              username: chattable["username"],
              phone: null,
              image: chattable["image"],
              fullname: chattable["fullname"],
              mobile: chattable["mobile"],
              imgPath: chattable["imgPath"],
              lastSeen: null,
            ),
          ));
    }
    update();
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    print("Check for message");
    print("onSubscriptionSucceeded: $channelName data: $data");
  }

  void onSubscriptionError(String message, dynamic e) {
    debugPrint("onSubscriptionError: $message Exception: $e");
  }

  void onMemberAdded(String channelName, PusherMember member) {
    debugPrint("onMemberAdded: $channelName member: $member");
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    debugPrint("onMemberRemoved: $channelName member: $member");
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    debugPrint("Connection: $currentState");
  }

  List<OfferCategory> offerCategoryList = [
    OfferCategory(name: "Latest Offer", value: "latest"),
    OfferCategory(name: "Price high to low", value: "high_to_low"),
    OfferCategory(name: "Price low to hight", value: "low_to_high"),
    OfferCategory(name: "Payment Processing", value: "processing"),
    OfferCategory(name: "Payment Completed", value: "complete"),
    OfferCategory(name: "Pending", value: "pending"),
    OfferCategory(name: "Rejected", value: "rejected"),
    OfferCategory(name: "Resubmission", value: "resubmission"),
  ];
}

class OfferCategory {
  final String name;
  final String value;
  OfferCategory({required this.name, required this.value});
}

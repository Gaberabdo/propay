import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamers_arena/controllers/conversation_controller.dart';
import 'package:gamers_arena/views/widgets/text_theme_extension.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/appDialog.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_textfield.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

class InboxScreen extends StatefulWidget {
  final String? uuid;
  final String? offerId;
  final String? sellPostId;
  final String? name;
  const InboxScreen(
      {super.key,
      this.uuid = "",
      this.offerId = "",
      this.sellPostId = "",
      this.name = ""});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  ScrollController scrollController = ScrollController();
  bool isShowEmoji = false;
  FocusNode focusNode = FocusNode();
  onBackspacePressed() {
    ConversationController.to.messageEditingCtrl
      ..text = ConversationController.to.messageEditingCtrl.text.characters
          .toString()
      ..selection = TextSelection.fromPosition(TextPosition(
          offset: ConversationController.to.messageEditingCtrl.text.length));
  }

  var controller = Get.put(ConversationController());
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.getChattingConfig();
    });
    focusNode.addListener(() {
      setState(() {
        if (focusNode.hasFocus) {
          if (isShowEmoji == true) {
            isShowEmoji = false;
          }
          Future.delayed(Duration(milliseconds: 500), () {
            scrollController.animateTo(
              scrollController.position.minScrollExtent,
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
            );
          });
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the FocusNode when it is no longer needed
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ConversationController>(builder: (convCtrl) {
      return Scaffold(
        backgroundColor:
            Get.isDarkMode ? const Color(0xff0E111F) : AppColors.whiteColor,
        appBar: buildAppBar(storedLanguage, context, convCtrl),
        body: Column(
          children: [
            convCtrl.isGettingConv
                ? Expanded(child: Container(child: Helpers.appLoader()))
                : convCtrl.reversedConversationList.isEmpty
                    ? const SizedBox()
                    : Expanded(
                        child: ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        reverse:
                            true, // To make the chat messages scroll from bottom to top
                        itemCount: convCtrl.reversedConversationList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var data = convCtrl.reversedConversationList[index];
                          return ListTile(
                            title: Column(
                              crossAxisAlignment:
                                  convCtrl.loginUserId != data.chatableId
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    convCtrl.timeVisible =
                                        !convCtrl.timeVisible;
                                    convCtrl.selectedIndex = index;
                                    convCtrl.update();
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        convCtrl.loginUserId != data.chatableId
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            convCtrl.loginUserId !=
                                                    data.chatableId
                                                ? MainAxisAlignment.start
                                                : MainAxisAlignment.end,
                                        children: [
                                          convCtrl.loginUserId !=
                                                  data.chatableId
                                              ? Container(
                                                  height: 34.h,
                                                  width: 34.h,
                                                  margin: EdgeInsets.only(
                                                      right: 12.w),
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.mainColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                data.chatable!
                                                                        .imgPath ??
                                                                    ""),
                                                            fit: BoxFit.cover)),
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                constraints: BoxConstraints(
                                                  maxWidth: 300.w,
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15.w,
                                                    vertical:
                                                        calculateVerticalPadding(
                                                            data.description
                                                                .toString()
                                                                .length)),
                                                decoration: BoxDecoration(
                                                  color: convCtrl.loginUserId ==
                                                          data.chatableId
                                                      ? AppColors.mainColor
                                                      : AppThemes
                                                          .getFillColor(), // User and admin message bubble color
                                                  borderRadius: convCtrl
                                                              .loginUserId !=
                                                          data.chatableId
                                                      ? BorderRadius.only(
                                                          bottomRight:
                                                              Radius.circular(
                                                                  40.r),
                                                          topRight:
                                                              Radius.circular(
                                                                  40.r),
                                                          topLeft:
                                                              Radius.circular(
                                                                  40.r),
                                                        )
                                                      : BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  40.r),
                                                          topRight:
                                                              Radius.circular(
                                                                  40.r),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  40.r),
                                                        ),
                                                  border: Border.all(
                                                      color:
                                                          AppColors.mainColor,
                                                      width: .2),
                                                ),
                                                child: Container(
                                                  constraints: BoxConstraints(
                                                    maxWidth: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        .5,
                                                  ),
                                                  child: Text(
                                                    data.description ?? "",
                                                    style: context
                                                        .t.displayMedium
                                                        ?.copyWith(
                                                      color: convCtrl
                                                                  .loginUserId ==
                                                              data.chatableId
                                                          ? AppColors.whiteColor
                                                          : Get.isDarkMode
                                                              ? AppColors
                                                                  .whiteColor
                                                              : AppColors
                                                                  .blackColor,
                                                    ), // User and admin message text color
                                                  ),
                                                ),
                                              ),
                                              VSpace(4.h),
                                              Visibility(
                                                  visible: convCtrl
                                                              .selectedIndex ==
                                                          index &&
                                                      convCtrl.timeVisible ==
                                                          true,
                                                  child: Text(
                                                    convCtrl.selectedIndex ==
                                                            index
                                                        ? '${data.formattedDate}'
                                                        : '',
                                                    style: context.t.bodySmall
                                                        ?.copyWith(
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .whiteColor
                                                                : AppColors
                                                                    .blackColor),
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )),
            Padding(
              padding: EdgeInsets.only(bottom: 15.h, left: 24.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 60.h,
                  maxHeight: 350.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: 46.h,
                              maxHeight: 100.h,
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: AppThemes.getFillColor(),
                                borderRadius: BorderRadius.circular(32.r),
                                border: Border.all(
                                    color: AppColors.mainColor, width: .2),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: AppTextField(
                                    focusNode: focusNode,
                                    controller: ConversationController
                                        .to.messageEditingCtrl,
                                    contentPadding: EdgeInsets.only(left: 20.w),
                                    maxLines: 8,
                                    hinText: "Type any text here",
                                  )),
                                  HSpace(3.w),
                                  InkResponse(
                                    onTap: () {
                                      setState(() {
                                        isShowEmoji = !isShowEmoji;
                                        Helpers.hideKeyboard();
                                      });
                                    },
                                    radius: 8.r,
                                    child: Image.asset(
                                      "$rootImageDir/emoji.png",
                                      height: 20.h,
                                    ),
                                  ),
                                  HSpace(15.w),
                                ],
                              ),
                            ),
                          ),
                        ),
                        HSpace(10.w),
                        InkResponse(
                          onTap: convCtrl.isCreatingNewMessage
                              ? null
                              : () {
                                  convCtrl.createNewMessage(fields: {
                                    "offer_id": widget.offerId.toString(),
                                    "sell_post_id":
                                        widget.sellPostId.toString(),
                                    "message": convCtrl.messageEditingCtrl.text,
                                  });
                                  scrollController.animateTo(
                                    scrollController.position.minScrollExtent,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.fastOutSlowIn,
                                  );
                                },
                          child: Container(
                            height: 46.h,
                            width: 46.h,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10.h),
                            decoration: BoxDecoration(
                              color: AppThemes.getFillColor(),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                  color: AppColors.mainColor, width: .2),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child:
                                  Image.asset("$rootImageDir/send_active.png"),
                            ),
                          ),
                        ),
                        HSpace(20.w),
                      ],
                    ),
                    if (isShowEmoji)
                      SizedBox(
                          height: 250.h,
                          child: EmojiPicker(
                            textEditingController:
                                ConversationController.to.messageEditingCtrl,
                            onBackspacePressed: onBackspacePressed,
                            config: Config(
                              columns: 11,
                              emojiSizeMax: 24.h,
                              verticalSpacing: 0,
                              horizontalSpacing: 0,
                              gridPadding: EdgeInsets.zero,
                              initCategory: Category.RECENT,
                              bgColor: Get.isDarkMode
                                  ? AppColors.darkBgColor
                                  : AppColors.whiteColor,
                              indicatorColor: AppColors.mainColor,
                              iconColor: Colors.grey,
                              iconColorSelected: AppColors.mainColor,
                              backspaceColor: AppColors.mainColor,
                              skinToneDialogBgColor: Colors.white,
                              skinToneIndicatorColor: Colors.grey,
                              enableSkinTones: true,
                              recentTabBehavior: RecentTabBehavior.RECENT,
                              recentsLimit: 28,
                              replaceEmojiOnLimitExceed: false,
                              noRecents: Text(
                                'No Recents',
                                style: context.t.titleSmall,
                                textAlign: TextAlign.center,
                              ),
                              loadingIndicator: const SizedBox.shrink(),
                              tabIndicatorAnimDuration: kTabScrollDuration,
                              categoryIcons: const CategoryIcons(),
                              buttonMode: ButtonMode.MATERIAL,
                              checkPlatformCompatibility: true,
                            ),
                          )),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  CustomAppBar buildAppBar(
      storedLanguage, BuildContext context, ConversationController convCtrl) {
    return CustomAppBar(
      bgColor: Get.isDarkMode ? const Color(0xff0E111F) : AppColors.whiteColor,
      title: "${widget.name}",
      fontSize: 19.sp,
      actions: [
        PopupMenuButton<String>(
          color: AppThemes.getDarkCardColor(),
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Payment Lock',
                child: Text(
                  storedLanguage['Payment Lock'] ?? "Payment Lock",
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
            ];
          },
          onSelected: (String selectedValue) {
            if (selectedValue == "Payment Lock") {
              appDialog(
                  context: context,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkResponse(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          padding: EdgeInsets.all(7.h),
                          decoration: BoxDecoration(
                            color: AppThemes.getFillColor(),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 14.h,
                            color: AppThemes.getIconBlackColor(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Are you sure to payment lock for ${widget.name}?",
                          style: context.t.displayMedium),
                      VSpace(25.h),
                      Text(storedLanguage['Amount'] ?? "Amount",
                          style: context.t.displayMedium),
                      VSpace(10.h),
                      CustomTextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        hintext:
                            storedLanguage['Enter amount'] ?? "Enter amount",
                        controller: convCtrl.offerAmountCtrl,
                        contentPadding: EdgeInsets.only(left: 20.w),
                      ),
                      VSpace(28.h),
                      GetBuilder<ConversationController>(builder: (convCtrl) {
                        return AppButton(
                          isLoading: convCtrl.isOfferLocking ? true : false,
                          text:storedLanguage['Submit'] ?? "Submit",
                          onTap: () async {
                            convCtrl.offerLock(fields: {
                              "offer_id": widget.offerId.toString(),
                              "amount": convCtrl.offerAmountCtrl.text,
                            });
                          },
                        );
                      }),
                    ],
                  ));
            }
          },
        ),
      ],
    );
  }

  double calculateVerticalPadding(int textLength) {
    if (textLength > 35) {
      return 20.h;
    } else {
      return 15.h;
    }
  }
}

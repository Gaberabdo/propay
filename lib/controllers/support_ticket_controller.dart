import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import '../data/models/support_ticketList_model.dart' as s;
import '../data/models/view_ticket_model.dart' as viewTicket;
import '../data/models/view_ticket_model.dart';
import '../data/repositories/support_ticket_repo.dart';
import '../data/source/check_status.dart';
import '../utils/services/helpers.dart';

class SupportTicketController extends GetxController {
  late ScrollController scrollController;
  int _page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<s.Data> ticketList = [];
  Future loadMore() async {
    if (_isLoading == false &&
        isLoadMore == false &&
        hasNextPage == true &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      _page += 1;
      await getTicketList(page: _page, isLoadMoreRunning: true);
      if (kDebugMode) {
        print("====================loaded from load more: " + _page.toString());
      }
      isLoadMore = false;
      update();
    }
  }

  bool isSearchTapped = false;
  resetDataAfterSearching({bool? isFromOnRefreshIndicator = false}) {
    ticketList.clear();
    isSearchTapped = true;
    hasNextPage = true;
    _page = 1;
    update();
  }

  Future getTicketList(
      {required int page, bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response =
        await SupportTicketRepo.getSupportTicketList(page: page);
    if (isLoadMoreRunning == false) {
      _isLoading = false;
    }
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final fetchedData = data['message']['data'];
        if (fetchedData.isNotEmpty) {
          ticketList
              .addAll(s.SupportTicketListModel.fromJson(data).message!.data!);
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          if (kDebugMode) {
            print("================isDataEmpty: false");
            print("================ticket list len: " +
                ticketList.length.toString());
          }
          update();
        } else {
          ticketList
              .addAll(s.SupportTicketListModel.fromJson(data).message!.data!);
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
      ticketList = [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    getTicketList(page: _page);
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    _isLoading = false;
    isCreatingTicket = false;
    ticketList.clear();
  }

  final List<String> _fileNames = [];

  FilePickerResult? result;
  List<dynamic> selectedFilePaths = []; // Store all selected file paths
  List<http.MultipartFile> files = [];

  Future<void> pickFiles() async {
    // Request storage permission
    final storageStatus = await Permission.storage.request();

    if (storageStatus.isGranted) {
      try {
        result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
        );

        if (result != null) {
          if (kDebugMode) {
            // print("==============File paths: ${result!.paths}");
          }
          _fileNames.addAll(result!.paths.map((path) => path!));
          selectedFilePaths.addAll(result!.paths
              .whereType<String>()); // Add selected paths to the list
          for (var path in selectedFilePaths) {
            files.addAll([
              await http.MultipartFile.fromPath("attachments[]", path),
            ]);
          }
          update();
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error while picking files: $e");
        }
      }
    } else {
      Helpers.showSnackBar(
          msg:
              "Please grant Storage permission in app settings to use this feature.");
    }
  }

  TextEditingController subjectEditingCtrl = TextEditingController();
  TextEditingController messageEditingCtrl = TextEditingController();
  bool isCreatingTicket = false;
  Future createTicket(context) async {
    isCreatingTicket = true;
    update();
    http.Response response =
        await SupportTicketRepo.createSupportTicket(fields: {
      "subject": subjectEditingCtrl.text.trim(),
      "message": messageEditingCtrl.text.trim(),
    }, fileList: files);
    isCreatingTicket = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        resetDataAfterSearching();
        getTicketList(page: 1);
        refreshCreateTicketData();
        Navigator.of(context).pop();
        update();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data}');
    }
  }

  refreshCreateTicketData() {
    selectedFilePaths.clear();
    files.clear();
    result = null;
    subjectEditingCtrl.clear();
    messageEditingCtrl.clear();
  }

  bool isViewingTicket = false;
  List<ViewTicketData> viewTicketList = [];
  Future getTicketView(
      {required String ticketId, bool? isFromCreatingTicket = false}) async {
    if (isFromCreatingTicket == false) {
      isViewingTicket = true;
      update();
    }

    http.Response response =
        await SupportTicketRepo.getSupportTicketView(ticket: ticketId);
    if (isFromCreatingTicket == false) {
      isViewingTicket = false;
    }
    viewTicketList = [];
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        viewTicketList.add(viewTicket.ViewTicketModel.fromJson(data).message!);
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      viewTicketList = [];
    }
  }

  TextEditingController replyTicketEditingCtrl = TextEditingController();
  bool replyEditingCtrlEmpty = true;
  bool isReplyingTicket = false;
  Future replyTicket(
      {required BuildContext context,
      bool? isCloseTicket = false,
      required String id}) async {
    isReplyingTicket = true;
    update();
    http.Response response =
        await SupportTicketRepo.replySupportTicket(fields: {
      "message": replyTicketEditingCtrl.text.trim(),
      "replayTicket": isCloseTicket == false ? "1" : "2",
      "id": "$id"
    }, fileList: files);
    isReplyingTicket = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (isCloseTicket == true) {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
      if (data['status'] == 'success') {
        resetDataAfterSearching();
        getTicketList(page: 1);
        refreshReplyTicketData();
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data}');
    }
  }

  refreshReplyTicketData() {
    selectedFilePaths.clear();
    files.clear();
    result = null;
    replyTicketEditingCtrl.clear();
    update();
  }

  // DOWNLOAD FILE FROM TICKET VIEW
  bool isDownloadPressed = false;
  String attachmentPath = "";
  String downloadCompleted = "";

  Future<void> downloadFile({
    BuildContext? context,
    required String fileUrl,
    required String fileName,
  }) async {
    Dio dio = Dio();
    if (await Permission.storage.request().isGranted) {
      final appDocDir = await DownloadsPath.downloadsDirectory();
      final appDocPath = appDocDir!.path;
      String savePath = appDocDir.path + "/$fileName";
      try {
        await dio.download(fileUrl, savePath,
            onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadCompleted =
                (received / total * 100).toStringAsFixed(0) + "%";
            isDownloadPressed = true;
            update();
          }
        });
        isDownloadPressed = false;
        update();
        ScaffoldMessenger.of(context!).showSnackBar(
            SnackBar(content: Text("File downloaded in ${appDocPath}")));
        OpenFile.open(savePath);
      } catch (e) {
        print("Error downloading file: $e");
      }
    } else {
      await Permission.storage.request();
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
          content: Text("Need Storage permission for downloading this file")));
    }
    update();
  }
}

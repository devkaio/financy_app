import 'package:flutter/foundation.dart';

import 'sync_service.dart';

class SyncController extends ChangeNotifier {
  SyncController({required this.syncService});

  final SyncService syncService;

  SyncState _state = SyncStateInitial();

  SyncState get state => _state;

  void _changeState(SyncState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> syncFromServer() async {
    _changeState(DownloadingDataFromServer());

    final result = await syncService.syncFromServer();

    result.fold(
      (error) => _changeState(DownloadDataFromServerError(error.message)),
      (_) => _changeState(DownloadedDataFromServer()),
    );
  }

  Future<void> syncToServer() async {
    _changeState(UploadingDataToServerState());

    final result = await syncService.syncToServer();

    result.fold(
      (error) => _changeState(UploadDataToServerError(error.message)),
      (_) => _changeState(UploadedDataToServer()),
    );
  }
}

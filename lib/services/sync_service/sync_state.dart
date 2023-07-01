abstract class SyncState {}

class SyncStateInitial extends SyncState {}

class SyncStateLoading extends SyncState {}

class UploadingDataToServerState extends SyncStateLoading {}

class DownloadingDataFromServer extends SyncStateLoading {}

class SyncStateError extends SyncState {
  SyncStateError(this.message);

  final String message;
}

class UploadDataToServerError extends SyncStateError {
  UploadDataToServerError(super.message);
}

class DownloadDataFromServerError extends SyncStateError {
  DownloadDataFromServerError(super.message);
}

class SyncStateSuccess extends SyncState {}

class UploadedDataToServer extends SyncStateSuccess {}

class DownloadedDataFromServer extends SyncStateSuccess {}

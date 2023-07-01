import 'package:financy_app/common/data/data.dart';
import 'package:financy_app/services/sync_service/sync_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock_classes.dart';

void main() {
  late MockSyncService mockSyncService;
  late SyncController sut;

  setUp(() {
    mockSyncService = MockSyncService();
    sut = SyncController(syncService: mockSyncService);
  });

  group('Tests SyncController State', () {
    group('when syncFromServer is called', () {
      test(
          '\n'
          'GIVEN: that the user has internet connection'
          '\n'
          'WHEN: the sync data from server is called and the data download is successful'
          '\n'
          'THEN: the state must change to DownloadedDataFromServer', () async {
        // Arrange
        expect(sut.state, isA<SyncStateInitial>());

        when(() => mockSyncService.syncFromServer())
            .thenAnswer((_) async => DataResult.success(null));

        await sut.syncFromServer();
        expect(sut.state, isA<DownloadedDataFromServer>());
      });

      test(
          '\n'
          'GIVEN: that the user has internet connection'
          '\n'
          'WHEN: the sync data from server is called and the data download is unsuccessful'
          '\n'
          'THEN: the state must change to DownloadDataFromServerError',
          () async {
        // Arrange
        expect(sut.state, isA<SyncStateInitial>());

        when(() => mockSyncService.syncFromServer()).thenAnswer((_) async =>
            DataResult.failure(const SyncException(code: 'error')));

        await sut.syncFromServer();
        expect(sut.state, isA<DownloadDataFromServerError>());
      });
    });

    group('when syntToServer is called', () {
      test(
          '\n'
          'GIVEN: that the user has internet connection'
          '\n'
          'WHEN: the sync data to server is called and the data upload is successful'
          '\n'
          'THEN: the state must change to UploadedDataToServer', () async {
        // Arrange
        expect(sut.state, isA<SyncStateInitial>());

        when(() => mockSyncService.syncToServer())
            .thenAnswer((_) async => DataResult.success(null));

        await sut.syncToServer();
        expect(sut.state, isA<UploadedDataToServer>());
      });

      test(
          '\n'
          'GIVEN: that the user has internet connection'
          '\n'
          'WHEN: the sync data to server is called and the data upload is unsuccessful'
          '\n'
          'THEN: the state must change to UploadDataToServerError', () async {
        // Arrange
        expect(sut.state, isA<SyncStateInitial>());

        when(() => mockSyncService.syncToServer()).thenAnswer((_) async =>
            DataResult.failure(const SyncException(code: 'error')));

        await sut.syncToServer();
        expect(sut.state, isA<UploadDataToServerError>());
      });
    });
  });
}

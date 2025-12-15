import 'package:flutter_clean_architecture/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'network_info_test.mocks.dart';
//class MockDataConnectionChecker extends Mock implements DataConnectionChecker {} ==  @GenerateMocks([DataConnectionChecker])
@GenerateMocks([DataConnectionChecker])
void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockDataConnectionChecker mockDataConnectionChecker;
  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('isConnected', () {
    test('should forward the call to DataConnectionCheck.hasConnection', () async {
      //Future.value(true) → Return directly un Future<bool> complete with true
      //arrange
      final tHasConnectionFuture = Future.value(true);
      when(
        mockDataConnectionChecker.hasConnection,
      ).thenAnswer((_) async => tHasConnectionFuture);

      // result = await networkInfoImpl.isConnected; => return a bool    ==> with await
      // result = networkInfoImpl.isConnected; => return a Future<bool>  ==> without await
      //act
      final result = networkInfoImpl.isConnected;

      //verify
      verify(mockDataConnectionChecker.hasConnection);
      //assert
      expect(result, tHasConnectionFuture);
    });
  });
}

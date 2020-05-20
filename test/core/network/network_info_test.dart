import 'package:anagramapp/core/network/network_info.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker{}

void main(){
  NetworkInfoImpl networkInfo;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp((){
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(connectionChecker: mockDataConnectionChecker);
  });

  final tHasConnectionFuture = Future<bool>.value(true);

  test('Should forward the call to DataConnectionChecker', (){
    //arrange
    when(mockDataConnectionChecker.hasConnection).thenAnswer((_) => tHasConnectionFuture);
    //act
    final result = networkInfo.isConnected;
    //assert
    verify(mockDataConnectionChecker.hasConnection);
    expect(result, equals(tHasConnectionFuture));
  });
}
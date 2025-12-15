import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/core/network/network_info.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasources/local/number_trivia_local_datasource.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasources/remote/number_trivia_remote_datasource.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/repositories/number_trivia_repositories_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_tirivia_repository_impl_test.mocks.dart';

/*
class MockRemoteDataSource extends Mock
implements NumberTriviaRemoteDatasource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}
instead of this => auto generate with GenerateMocks
*/
@GenerateMocks([
  NumberTriviaRemoteDatasource,
  NumberTriviaLocalDatasource,
  NetworkInfo,
])
void main() {
  late NumberTriviaRepositoriesImpl repository;
  late MockNumberTriviaRemoteDatasource mockRemoteDataSource;
  late MockNumberTriviaLocalDatasource mockLocalDataSource;
  late MockNetworkInfo mockNetWorkInfo;
  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDatasource();
    mockLocalDataSource = MockNumberTriviaLocalDatasource();
    mockNetWorkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoriesImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetWorkInfo,
    );
  });
  void runTestOnline(Function body) {
    group("device is online", () {
      setUp(() {
        when(mockNetWorkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group("device is online", () {
      setUp(() {
        when(mockNetWorkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getconcretenumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(
      number: tNumber,
      text: 'test trivia',
    );

    final NumberTriviaModel tNumberTrivia = tNumberTriviaModel;
    test('Should check if the device is online', () async {
      //arrange
      when(mockNetWorkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.getConcreteNumberTrivia(tNumber),
      ).thenAnswer((_) async => tNumberTriviaModel);

      //act
      await repository.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockNetWorkInfo.isConnected).called(1); //ensure the this is called
    });

    runTestOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          //arrange
          //data source => return model
          when(
            mockRemoteDataSource.getConcreteNumberTrivia(1),
          ).thenAnswer((_) async => tNumberTriviaModel);

          //act
          final result = await repository.getConcreteNumberTrivia(
            tNumber,
          ); //without await you will return future instance

          //verify
          verify(
            mockRemoteDataSource.getConcreteNumberTrivia(tNumber),
          ); //verify that getConcreteNumberTrivia has been called with prop parameters
          //expect
          expect(result, equals(Right(tNumberTrivia))); //repo return an entity
        },
      );
      test(
        'should cache data locally when the call to remote data source is successful',
        () async {
          //arrange
          //data source => return model
          when(
            mockRemoteDataSource.getConcreteNumberTrivia(1),
          ).thenAnswer((_) async => tNumberTriviaModel);

          //act
          await repository.getConcreteNumberTrivia(
            tNumber,
          ); //without await you will return future instance

          //verify
          verify(
            mockRemoteDataSource.getConcreteNumberTrivia(tNumber),
          ); //verify that getConcreteNumberTrivia has been called with prop parameters
          verify(
            mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
          ); //should cache data when remote call succeeds
        },
      );
      test(
        'should return server failure when the call to remote data source fails',
        () async {
          //arrange
          //data source => throw exception
          when(
            mockRemoteDataSource.getConcreteNumberTrivia(1),
          ).thenThrow(ServerExceptions());

          //act
          final result = await repository.getConcreteNumberTrivia(
            tNumber,
          ); //without await you will return future instance
          //verify
          verify(
            mockRemoteDataSource.getConcreteNumberTrivia(tNumber),
          ); //verify that getConcreteNumberTrivia has been called with prop parameters
          verifyZeroInteractions(
            mockLocalDataSource,
          ); //no caching when remote data source throws exception
          //expect
          expect(result, equals(Left(ServerFailure()))); //repo returns failure
        },
      );
    });
    runTestOffline(() {
      //when offline return cached data
      test(
        'Should return locally cached data when the cached data is present',
        () async {
          //arrange
          when(
            mockLocalDataSource.getLastNumberTrivia(),
          ).thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());

          //assert
          expect(result, equals(Right(tNumberTrivia)));
        },
      );
      test(
        'Should return cache failure data when no data cached data present',
        () async {
          //arrange
          when(
            mockLocalDataSource.getLastNumberTrivia(),
          ).thenThrow(CacheException());
          //act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());

          //assert
          expect(result, equals(left(CacheFailure())));
        },
      );
    });
  });
  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(
      number: 123,
      text: 'test trivia',
    );

    final NumberTriviaModel tNumberTrivia = tNumberTriviaModel;
    test('Should check if the device is online', () async {
      //arrange
      when(mockNetWorkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.getRandomNumberTrivia(),
      ).thenAnswer((_) async => tNumberTriviaModel);

      //act
      await repository.getRandomNumberTrivia();
      //assert
      verify(mockNetWorkInfo.isConnected).called(1); //ensure the this is called
    });

    runTestOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          //arrange
          //data source => return model
          when(
            mockRemoteDataSource.getRandomNumberTrivia(),
          ).thenAnswer((_) async => tNumberTriviaModel);

          //act
          final result = await repository
              .getRandomNumberTrivia(); //without await you will return future instance

          //verify
          verify(
            mockRemoteDataSource.getRandomNumberTrivia(),
          ); //verify that getConcreteNumberTrivia has been called with prop parameters
          //expect
          expect(result, equals(Right(tNumberTrivia))); //repo return an entity
        },
      );
      test(
        'should cache data locally when the call to remote data source is successful',
        () async {
          //arrange
          //data source => return model
          when(
            mockRemoteDataSource.getRandomNumberTrivia(),
          ).thenAnswer((_) async => tNumberTriviaModel);

          //act
          await repository
              .getRandomNumberTrivia(); //without await you will return future instance

          //verify
          verify(
            mockRemoteDataSource.getRandomNumberTrivia(),
          ); //verify that getConcreteNumberTrivia has been called with prop parameters
          verify(
            mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
          ); //should cache data when remote call succeeds
        },
      );
      test(
        'should return server failure when the call to remote data source fails',
        () async {
          //arrange
          //data source => throw exception
          when(
            mockRemoteDataSource.getRandomNumberTrivia(),
          ).thenThrow(ServerExceptions());

          //act
          final result = await repository
              .getRandomNumberTrivia(); //without await you will return future instance
          //verify
          verify(
            mockRemoteDataSource.getRandomNumberTrivia(),
          ); //verify that getConcreteNumberTrivia has been called with prop parameters
          verifyZeroInteractions(
            mockLocalDataSource,
          ); //no caching when remote data source throws exception
          //expect
          expect(result, equals(Left(ServerFailure()))); //repo returns failure
        },
      );
    });
    runTestOffline(() {
      //when offline return cached data
      test(
        'Should return locally cached data when the cached data is present',
        () async {
          //arrange
          when(
            mockLocalDataSource.getLastNumberTrivia(),
          ).thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result = await repository.getRandomNumberTrivia();
          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());

          //assert
          expect(result, equals(Right(tNumberTrivia)));
        },
      );
      test(
        'Should return cache failure data when no data cached data present',
        () async {
          //arrange
          when(
            mockLocalDataSource.getLastNumberTrivia(),
          ).thenThrow(CacheException());
          //act
          final result = await repository.getRandomNumberTrivia();
          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());

          //assert
          expect(result, equals(left(CacheFailure())));
        },
      );
    });
  });
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_clean_architecture/core/error/failures.dart';

///generic abstract class for a Use Case
///
///UseCase<NumberTrivia, Params> =>Type is NumberTrivia, meaning the use case will return a NumberTrivia object on success
///
///This represents the input parameters needed to execute the use case.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

//because there are other use case they will use the NoParam
class NoPrams extends Equatable {
  @override
  List<Object?> get props => [];
}

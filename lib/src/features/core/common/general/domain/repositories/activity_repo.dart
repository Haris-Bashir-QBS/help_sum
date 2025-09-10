import 'package:dartz/dartz.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/core/common/general/domain/entities/recent_message_entity.dart';

abstract class ActivityRepo {
  Future<Either<Failure, List<RecentMessageEntity>>> getInboxMessages();
}

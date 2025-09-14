import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/core/common/chat/domain/entities/inbox_chat_entity.dart';
import 'package:help_sum/src/features/core/common/chat/domain/repositories/chat_repository.dart';

class GetInboxChatsUseCase extends UseCase<List<InboxChatEntity>, NoParams> {
  final ChatRepository _chatRepository;

  GetInboxChatsUseCase({required ChatRepository chatRepository})
      : _chatRepository = chatRepository;

  @override
  Future<Either<Failure, List<InboxChatEntity>>> call(NoParams params) async {
    return await _chatRepository.getInboxChats();
  }
}

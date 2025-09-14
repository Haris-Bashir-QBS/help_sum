import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/core/common/chat/domain/repositories/chat_repository.dart';

class SendMessageParams {
  final String receiverId;
  final String message;
  final String type;
  final String? mediaUrl;

  const SendMessageParams({
    required this.receiverId,
    required this.message,
    this.type = 'text',
    this.mediaUrl,
  });
}

class SendMessageUseCase extends UseCase<void, SendMessageParams> {
  final ChatRepository _chatRepository;

  SendMessageUseCase({required ChatRepository chatRepository})
      : _chatRepository = chatRepository;

  @override
  Future<Either<Failure, void>> call(SendMessageParams params) async {
    return await _chatRepository.sendMessage(
      receiverId: params.receiverId,
      message: params.message,
      type: params.type,
      mediaUrl: params.mediaUrl,
    );
  }
}

import 'package:equatable/equatable.dart';

class MerchantSetupResponseEntitiy extends Equatable {
  final String? url;
  final String? message;

  const MerchantSetupResponseEntitiy({this.url, this.message});

  @override
  List<Object?> get props => [url, message];
}

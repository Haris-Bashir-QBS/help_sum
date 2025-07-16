import 'package:equatable/equatable.dart';

class MerchantSetupResposeEntitiy extends Equatable {
  final String? url;
  final String? message;

  const MerchantSetupResposeEntitiy({this.url, this.message});

  @override
  List<Object?> get props => [url];
}

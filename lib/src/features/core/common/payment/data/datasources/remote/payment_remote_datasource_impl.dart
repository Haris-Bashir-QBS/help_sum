import 'dart:developer';

import 'package:help_sum/src/core/extensions/dio_extensions.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/network/client/dio_client.dart';
import 'package:help_sum/src/core/network/config/api_endpoints.dart';
import 'package:help_sum/src/core/network/config/error_handler.dart';
import 'package:help_sum/src/core/constants/app_errors.dart';
import 'package:help_sum/src/features/core/common/payment/data/datasources/remote/payment_remote_datasource.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/request/add_card_request_model.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/request/rate_job_request_model.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/add_card_response_model.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/get_cards_response_model.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/card_action_response_model.dart';

class PaymentRemoteDataSourceImplementation implements PaymentRemoteDataSource {
  final DioClient _client;

  PaymentRemoteDataSourceImplementation({required DioClient client})
    : _client = client;

  @override
  Future<AddCardResponseModel> addCard({
    required AddCardRequestModel params,
  }) async {
    return await ApiErrorHandler.executeGuarded(() async {
      final response = await _client.post(
        endpoint: ApiEndpoints.addCard.value,
        data: params.toJson(),
      );
      log("Add Card Response: ${response.data}");
      if (response.isOk || response.isCreated) {
        return AddCardResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }

  @override
  Future<GetCardsResponseModel> getCards() async {
    return await ApiErrorHandler.executeGuarded(() async {
      final response = await _client.get(endpoint: ApiEndpoints.getCards.value);
      log("Get Cards Response: ${response.data}");
      if (response.isOk) {
        return GetCardsResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }

  @override
  Future<CardActionResponseModel> deleteCard({required String cardId}) async {
    return await ApiErrorHandler.executeGuarded(() async {
      final response = await _client.delete(
        endpoint: "${ApiEndpoints.deleteCard.value}/$cardId",
      );
      log("Delete Card Response: ${response.data}");
      if (response.isOk) {
        return CardActionResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }

  @override
  Future<CardActionResponseModel> setDefaultCard({
    required String cardId,
  }) async {
    return await ApiErrorHandler.executeGuarded(() async {
      final response = await _client.put(
        endpoint: "${ApiEndpoints.setDefaultCard.value}/$cardId",
      );
      log("Set Default Card Response: ${response.data}");
      if (response.isOk) {
        return CardActionResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }

  @override
  Future<CardActionResponseModel> payForJob({
    required String jobId,
    required String paymentToken,
    required int amount,
  }) async {
    return await ApiErrorHandler.executeGuarded(() async {
      final response = await _client.post(
        endpoint: "${ApiEndpoints.jobPayment.value}/$jobId/payment",
        data: {"paymentToken": paymentToken, "amount": amount},
      );
      log("Pay For Job Response: ${response.data}");
      if (response.isOk || response.isCreated) {
        return CardActionResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }

  @override
  Future<CardActionResponseModel> rateJob({
    required RateJobRequestModel params,
  }) async {
    return await ApiErrorHandler.executeGuarded(() async {
      final response = await _client.post(
        endpoint: "${ApiEndpoints.rateJob.value}/${params.jobId}/rate",
        data: {
          "rating": params.rating,
          "review": params.review,
        },
      );
      log("Rate Job Response: ${response.data}");
      if (response.isOk || response.isCreated) {
        return CardActionResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }
}

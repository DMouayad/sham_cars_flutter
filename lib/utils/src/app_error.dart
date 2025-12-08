import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sham_cars/utils/utils.dart';

sealed class BaseAppError {
  String getMessage(BuildContext context);
}

class ApiError extends Equatable implements BaseAppError {
  final String? message;
  final Object? extra;
  final AppError appErr;

  const ApiError({this.message, this.extra, required this.appErr});

  @override
  List<Object?> get props => [message, extra, appErr];

  @override
  bool? get stringify => false;

  @override
  String getMessage(BuildContext context) {
    return appErr.getMessage(context);
  }
}

enum AppError implements BaseAppError {
  /// A custom exception in the application domain.
  ///
  /// - Call `getMessage(context)` to get the translated message of a thrown exception.
  // Connection & Internet
  noInternetConnectionFound,
  locationServiceDisabled,
  locationPermissionDenied,
  locationPermissionDeniedPermanently,
  cannotConnectToServer,
  // Authorization
  unauthorized,
  // Authentication
  unauthenticated,
  accountAlreadyExist,
  invalidLoginCredential,
  // Custom API errors & HTTP requests
  invalidApiRequest,
  unknownApiError(code: 'UNKNOWN_ERROR'),
  serverError(code: 'SERVER_ERROR'),
  badRequest(code: 'BAD_REQUEST'),
  routeNotFound(code: 'ROUTE_NOT_FOUND'),
  emptyRequestBody(code: 'EMPTY_REQUEST_BODY'),
  invalidContentType(code: 'INVALID_CONTENT_TYPE'),
  wrongLoginCreds(code: 'WRONG_LOGIN_CREDS'),
  forbidden(code: 'FORBIDDEN'),
  validation(code: 'VALIDATION'),
  accountAlreadyExists(code: 'ACCOUNT_ALREADY_EXISTS'),
  signupFailed(code: 'SIGNUP_FAILED'),
  entityNotFound(code: 'ENTITY_NOT_FOUND'),
  invalidPat(code: 'INVALID_PAT'),
  unverifiedEmailOrPhone(code: 'UNVERIFIED_EMAIL_OR_PHONE'),
  unverifiedEmailAndPhone(code: 'UNVERIFIED_EMAIL_AND_PHONE'),
  emailAlreadyVerified(code: 'EMAIL_ALREADY_VERIFIED'),
  phoneAlreadyVerified(code: 'PHONE_ALREADY_VERIFIED'),
  invalidOtp(code: 'INVALID_OTP'),
  expiredOtp(code: 'EXPIRED_OTP'),
  confirmIdentity(code: 'CONFIRM_IDENTITY'),
  resourceAlreadyExists(code: 'RESOURCE_ALREADY_EXISTS'),
  rateLimitExceeded(code: 'RATE_LIMIT_EXCEEDED'),
  // Misc
  notFound,
  decodingJsonFailed,

  /// Indicates that an unknown error has occurred or an un expected exception
  /// was thrown.
  ///
  /// - This applies for unregistered\unknown API exceptions,
  /// an exception from external packages, etc.
  /// - This error should be found in the logs to.
  undefined;

  const AppError({this.code});
  final String? code;

  static AppError? byNameOrNull(String? name) {
    try {
      return name != null ? AppError.values.byName(name) : null;
    } catch (_) {
      return null;
    }
  }

  @override
  String getMessage(BuildContext context) {
    return switch (this) {
      AppError.noInternetConnectionFound => context.l10n.noInternetConnection,
      AppError.cannotConnectToServer => context.l10n.cannotConnectToServer,
      AppError.unauthorized => context.l10n.unauthorized,
      AppError.unauthenticated => context.l10n.unauthenticated,
      AppError.accountAlreadyExist => context.l10n.accountAlreadyExist,
      AppError.invalidLoginCredential => context.l10n.invalidLoginCredential,
      AppError.locationPermissionDenied =>
        context.l10n.locationPermissionDenied,
      AppError.locationPermissionDeniedPermanently =>
        context.l10n.locationPermissionDeniedPermanently,
      AppError.locationServiceDisabled => context.l10n.locationServiceDisabled,
      AppError.notFound => context.l10n.notFound,
      AppError.decodingJsonFailed => context.l10n.decodingJsonFailed,
      AppError.badRequest => context.l10n.badRequest,
      AppError.routeNotFound => context.l10n.routeNotFound,
      AppError.emptyRequestBody => context.l10n.emptyRequestBody,
      AppError.invalidContentType => context.l10n.invalidContentType,
      AppError.wrongLoginCreds => context.l10n.wrongLoginCreds,
      AppError.forbidden => context.l10n.forbidden,
      AppError.validation => context.l10n.validation,
      AppError.accountAlreadyExists => context.l10n.accountAlreadyExists,
      AppError.signupFailed => context.l10n.signupFailed,
      AppError.emailAlreadyVerified => context.l10n.emailAlreadyVerified,
      AppError.phoneAlreadyVerified => context.l10n.phoneAlreadyVerified,
      AppError.invalidOtp => context.l10n.invalidOTP,
      AppError.expiredOtp => context.l10n.expiredOTP,
      AppError.confirmIdentity => context.l10n.confirmIdentity,
      AppError.rateLimitExceeded => context.l10n.rateLimitExceeded,
      AppError.invalidApiRequest ||
      AppError.serverError ||
      AppError.unknownApiError ||
      AppError.undefined => context.l10n.serverError,
      _ => context.l10n.serverError,
    };
  }

  factory AppError.fromHttpResponse(int statusCode) {
    return switch (statusCode) {
      HttpStatus.unauthorized => AppError.unauthenticated,
      HttpStatus.notFound => AppError.notFound,
      HttpStatus.badRequest => AppError.invalidApiRequest,
      _ => AppError.serverError,
    };
  }
  static AppError? fromApiErrCode(String errCode) {
    final matched = AppError.values.firstWhere(
      (exp) => exp.code == errCode,
      orElse: () => AppError.undefined,
    );
    return (matched == AppError.undefined) ? null : matched;
  }
}

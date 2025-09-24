import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '/bkash/apis/bkash_apis.dart';
import '../routes/app_route.dart';
import 'models/create_payment_response.dart';
import 'models/execute_payment_response.dart';
import 'models/grant_token_response.dart';

class Bkash {
  /// Initiates and executes the bKash payment process
  static Future<ExecutePaymentResponse?> payment({
    required BuildContext context,
    required bool production,
    required String amount,
  }) async {
    try {
      // Step 1: Get grant token
      final grantTokenResponse = await _getGrantToken(production);

      // Step 2: Create payment
      final createPaymentResponse = await _createPayment(
        production,
        grantTokenResponse.idToken,
        amount,
      );

      // Step 3: Open bKash webview
      final paymentResult = await _openBkashWebView(
        context,
        createPaymentResponse,
      );

      // Step 4: If success, execute payment
      if (paymentResult == "success") {
        final response = await executePayment(
          production,
          grantTokenResponse.idToken,
          createPaymentResponse.paymentID,
        );
        return response; // Return payment result
      } else {
        Fluttertoast.showToast(msg: "Payment Failed or Cancelled");
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Payment Error: $e');
      debugPrint('Payment Error: $e');
      return null;
    }
  }

  /// Retrieves grant token from bKash API
  static Future<GrantTokenResponse> _getGrantToken(production) async {
    return await BkashApis(production).grantToken();
  }

  /// Creates a new bKash payment request
  static Future<CreatePaymentResponse> _createPayment(
    production,
    String idToken,
    String amount,
  ) async {
    return await BkashApis(production).createPayment(
      idToken: idToken,
      amount: amount,
      invoiceNumber: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  /// Opens WebView for bKash payment
  // static Future<String?> _openBkashWebView(
  //   BuildContext context,
  //   CreatePaymentResponse payment,
  // ) async {
  //   return await context.push<String>(
  //     () => BkashWebView(
  //       url: payment.bkashURL,
  //       successURL: payment.successCallbackURL,
  //       failureURL: payment.failureCallbackURL,
  //       cancelURL: payment.cancelledCallbackURL,
  //     ),
  //   );
  // }
  static Future<String?> _openBkashWebView(
    BuildContext context,
    CreatePaymentResponse payment,
  ) async {
    // Push the route and wait for a result
    final result = await context.push<String>(
      AppRoute.bkash.path,
      extra: payment,
    );

    return result; // same as Get.to return
  }

  //
  static Future<ExecutePaymentResponse?> executePayment(
    bool production,
    String idToken,
    String paymentID,
  ) async {
    final executePaymentResponse = await BkashApis(
      production,
    ).executePayment(idToken: idToken, paymentID: paymentID);

    if (executePaymentResponse.transactionStatus == "Completed") {
      // Success
      return executePaymentResponse;
    } else {
      Fluttertoast.showToast(msg: "Payment Execution Failed!");
      return null;
    }
  }
}

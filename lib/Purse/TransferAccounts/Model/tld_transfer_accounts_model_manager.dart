import 'package:dragon_sword_purse/Base/tld_base_request.dart';
import 'package:dragon_sword_purse/CommonModelManager/tld_qr_code_model_manager.dart';
import 'package:dragon_sword_purse/Purse/FirstPage/Model/tld_wallet_info_model.dart';

class TLDTranferAmountPramaterModel {
  String chargeValue;
  String chargeWalletAddress;
  String fromWalletAddress;
  String toWalletAddress;
  String value;
  bool isRecharge;
}

class TLDTransferAccountsModelManager {
  void getAddressFromQrCode(
      String qrCode, Function(String) success, Function(TLDError) failure) {
    if (qrCode.contains('http://www.tldollar.com')) {
      if (qrCode.contains('walletAddress')) {
        Uri uri = Uri.parse(qrCode);
        String walletAddress = uri.queryParameters['walletAddress'];
        success(walletAddress);
      } else {
        TLDError error = TLDError(500, '无法识别的二维码');
        failure(error);
      }
    } else if (qrCode.contains('isTLD')) {
      Uri url = Uri.parse(qrCode);
      if (url.queryParameters['codeType'] != null) {
        if (int.parse(url.queryParameters['codeType']) == 2) {
          if (url.queryParameters['walletAddress'] != null) {
            String redEnvelopeId = url.queryParameters['walletAddress'];
            success(redEnvelopeId);
          } else {
            TLDError error = TLDError(500, '无法识别的二维码');
            failure(error);
          }
        }
      } else {
        TLDError error = TLDError(500, '无法识别的二维码');
        failure(error);
      }
    } else {
      TLDError error = TLDError(500, '无法识别的二维码');
      failure(error);
    }
  }

  void transferAmount(TLDTranferAmountPramaterModel pramaterModel,
      Function(int) success, Function(TLDError) failure) {
    Map pramaterMap = {
      'chargeValue': pramaterModel.chargeValue,
      'chargeWalletAddress': pramaterModel.chargeWalletAddress,
      'fromWalletAddress': pramaterModel.fromWalletAddress,
      'toWalletAddress': pramaterModel.toWalletAddress,
      'value': pramaterModel.value,
    };
    if (pramaterModel.isRecharge != null) {
      pramaterMap.addEntries({'type': 1}.entries);
    }
    TLDBaseRequest request = TLDBaseRequest(pramaterMap, 'wallet/transfer');
    request.isNeedSign = true;
    request.walletAddress = pramaterModel.fromWalletAddress;
    request.postNetRequest((dynamic value) {
      int txId = value['txId'];
      success(txId);
    }, (error) => failure(error));
  }

  void getWalletInfo(String walletAddress, Function(TLDWalletInfoModel) success,
      Function(TLDError) failure) {
    TLDBaseRequest request = TLDBaseRequest(
        {'walletAddress': walletAddress}, 'wallet/queryOneWallet');
    request.postNetRequest((value) {
      Map data = value;
      success(TLDWalletInfoModel.fromJson(data));
    }, (error) => failure(error));
  }
}

import 'apiservice.dart';
import '../models/codepromo.dart';

class CodePromoService extends ApiService {
  CodePromoService() : super('http://10.0.2.2:9092/api');

  Future<List<CodePromo>> fetchPromoCodes() async {
    return await get('code-promo', (json) => CodePromo.fromJson(json));
  }

  Future<CodePromo> addPromoCode(CodePromo promoCode) async {
    return await post('code-promo', promoCode.toJson(), (json) => CodePromo.fromJson(json));
  }

  Future<void> deletePromoCode(int id) async {
    await delete('code-promo/$id');
  }
}


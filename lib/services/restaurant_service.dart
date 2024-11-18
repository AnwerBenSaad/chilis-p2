import 'apiservice.dart';
import '../models/restaurant.dart';

class RestaurantService extends ApiService {
  RestaurantService() : super('http://10.0.2.2:9092/api');

  Future<List<Restaurant>> fetchRestaurants() async {
    return await get('restaurants', (json) => Restaurant.fromJson(json));
  }

  Future<Restaurant> addRestaurant(Restaurant restaurant) async {
    return await post('restaurants', restaurant.toJson(), (json) => Restaurant.fromJson(json));
  }

  Future<Restaurant> updateRestaurant(Restaurant restaurant) async {
    return await put('restaurants/${restaurant.id}', restaurant.toJson(), (json) => Restaurant.fromJson(json));
  }

  Future<void> deleteRestaurant(int id) async {
    await delete('restaurants/$id');
  }
}

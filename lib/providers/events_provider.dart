// lib/providers/events_provider.dart
import 'dart:io';
import 'package:get/get.dart';
import 'package:qr_app/providers/api_provider.dart';
import 'package:http/http.dart' as http;
import 'package:qr_app/utils/const.dart';
import 'package:qr_app/env/env.dart';

class EventProvider extends ApiProvider {
  // GET /api/event
  Future<Response> getEvents() async {
    return get('/event');
  }

  // GET /api/event/{id}
  Future<Response> getEvent(String id) async {
    return get('/event/$id');
  }

  // POST /api/event dengan images
  Future<Response> createEvent({
    required String name,
    required String desc,
    required String date,
    required int maxReservation,
    List<File>? images,
  }) async {
    try {
      final token = await storage.read(key: Const.tokenKey);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Const.baseApiUrl}/event'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      request.headers['x-api-key'] = Env.apiKey;

      request.fields['name'] = name;
      request.fields['desc'] = desc;
      request.fields['date'] = date;
      request.fields['max_reservation'] = maxReservation.toString();

      if (images != null && images.isNotEmpty) {
        for (var image in images) {
          request.files.add(
            await http.MultipartFile.fromPath('images[]', image.path),
          );
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return Response(
        statusCode: response.statusCode,
        body: response.body,
        bodyString: response.body,
        statusText: response.reasonPhrase,
      );
    } catch (e) {
      return Response(statusCode: 500, statusText: e.toString());
    }
  }

  // POST /api/event/{id} dengan images
  Future<Response> updateEvent({
    required String id,
    required String name,
    required String desc,
    required String date,
    required int maxReservation,
    List<File>? images,
  }) async {
    try {
      final token = await storage.read(key: Const.tokenKey);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Const.baseApiUrl}/event/$id'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      request.headers['x-api-key'] = Env.apiKey;

      request.fields['name'] = name;
      request.fields['desc'] = desc;
      request.fields['date'] = date;
      request.fields['max_reservation'] = maxReservation.toString();

      if (images != null && images.isNotEmpty) {
        for (var image in images) {
          request.files.add(
            await http.MultipartFile.fromPath('images[]', image.path),
          );
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return Response(
        statusCode: response.statusCode,
        body: response.body,
        bodyString: response.body,
        statusText: response.reasonPhrase,
      );
    } catch (e) {
      return Response(statusCode: 500, statusText: e.toString());
    }
  }

  // DELETE /api/event/{id}
  Future<Response> deleteEvent(String id) async {
    return delete('/event/$id');
  }

  // GET /api/event/{id}/ticket (admin only)
  Future<Response> getEventTickets(String eventId) async {
    return get('/event/$eventId/ticket');
  }

  // PATCH /api/checkin
  Future<Response> checkIn({required String code}) async {
    return patch('/checkin', {'code': code});
  }
}

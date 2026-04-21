import 'package:get/get.dart';
import 'package:qr_app/providers/api_provider.dart';

class TicketsProvider extends ApiProvider {
  Future<Response> getMyTickets() async {
    return get('/my-tickets');
  }

  Future<Response> cancelTicket(String ticketId) async {
    return patch('/ticket/$ticketId/cancel', {});
  }

  Future<Response> reserveTicket(String eventId) async {
    return post('/event/$eventId/reserve', {});
  }
}

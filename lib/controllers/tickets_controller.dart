import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_app/models/ticket_model.dart';
import 'package:qr_app/providers/tickets_provider.dart';
import 'package:qr_app/utils/show_snack.dart';

class TicketsController extends GetxController {
  final TicketsProvider _provider = Get.put(TicketsProvider());

  RxBool isLoading = false.obs;
  RxList<Ticket> allTickets = <Ticket>[].obs;

  List<Ticket> get activeTickets =>
      allTickets.where((t) => t.isActive).toList();
  List<Ticket> get usedTickets =>
      allTickets.where((t) => t.isUsed).toList();
  List<Ticket> get canceledTickets =>
      allTickets.where((t) => t.isCancelledStatus).toList();

  @override
  void onInit() {
    super.onInit();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    isLoading(true);
    try {
      final res = await _provider.getMyTickets();
      if (res.isOk) {
        // ✅ Handle jika data null atau bukan list
        final dynamic raw = res.body['data'];
        if (raw is List) {
          allTickets.value = raw.map((e) => Ticket.fromJson(e)).toList();
        } else {
          allTickets.value = [];
        }
      } else {
        final msg = res.body != null
            ? (res.body['message'] ?? 'Gagal memuat tiket')
            : 'Gagal memuat tiket';
        ShowSnack.error(msg.toString());
      }
    } catch (e) {
      ShowSnack.error('Terjadi kesalahan: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> reserveTicket(String eventId) async {
    isLoading(true);
    try {
      final res = await _provider.reserveTicket(eventId);
      if (res.isOk) {
        ShowSnack.success('Berhasil mendaftar! Cek tab My Tickets.');
        await fetchTickets();
      } else {
        final msg = res.body != null
            ? (res.body['message'] ?? 'Gagal mendaftar')
            : 'Gagal mendaftar';
        ShowSnack.error(msg.toString());
      }
    } catch (e) {
      ShowSnack.error('Terjadi kesalahan koneksi');
    } finally {
      isLoading(false);
    }
  }

  Future<void> cancelTicket(Ticket ticket) async {
    try {
      final res = await _provider.cancelTicket(ticket.id!);
      if (res.isOk) {
        ShowSnack.success('Ticket canceled');
        await fetchTickets();
      } else {
        final msg = res.body != null
            ? (res.body['message'] ?? 'Gagal membatalkan tiket')
            : 'Gagal membatalkan tiket';
        ShowSnack.error(msg.toString());
      }
    } catch (e) {
      ShowSnack.error(e.toString());
    }
  }

  void showCancelDialog(BuildContext context, Ticket ticket) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161C2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF1F2840)),
        ),
        title: const Text(
          'Cancel Ticket',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        content: Text(
          'Cancel your ticket for "${ticket.event?.name ?? 'this event'}"?\nThis cannot be undone.',
          style: const TextStyle(
            color: Color(0xFF5A6080),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Keep Ticket',
              style: TextStyle(
                color: Color(0xFF5A6080),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              cancelTicket(ticket);
            },
            child: const Text(
              'Cancel Ticket',
              style: TextStyle(
                color: Color(0xFFFF6B6B),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
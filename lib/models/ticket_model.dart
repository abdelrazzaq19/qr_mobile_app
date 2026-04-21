import 'dart:convert';

import 'package:qr_app/models/events_model.dart';

Ticket ticketFromJson(String str) => Ticket.fromJson(json.decode(str));

String ticketToJson(Ticket data) => json.encode(data.toJson());

class Ticket {
  String? id;
  int? userId;
  String? eventId;
  String? code;
  DateTime? checkedAt;
  bool? isCanceled;
  DateTime? createdAt;
  DateTime? updatedAt;
  Event? event;

  Ticket({
    this.id,
    this.userId,
    this.eventId,
    this.code,
    this.checkedAt,
    this.isCanceled,
    this.createdAt,
    this.updatedAt,
    this.event,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        id: json["id"]?.toString(),
        userId: json["user_id"] == null
            ? null
            : int.tryParse(json["user_id"].toString()),
        eventId: json["event_id"]?.toString(),
        // ✅ Fix: parsing boolean yang benar
        code: json["code"]?.toString(),
        checkedAt: json["checked_at"] == null
            ? null
            : DateTime.parse(json["checked_at"]),
        // ✅ Fix: dulu logicnya salah, sekarang benar
        isCanceled: json["is_canceled"] == true ||
            json["is_canceled"] == 1 ||
            json["is_canceled"] == "1",
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        event: json["event"] == null ? null : Event.fromJson(json["event"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "event_id": eventId,
        "code": code,
        "checked_at": checkedAt?.toIso8601String(),
        "is_canceled": isCanceled,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "event": event?.toJson(),
      };

  // Status helpers
  bool get isActive => !(isCanceled ?? false) && checkedAt == null;
  bool get isUsed => checkedAt != null && !(isCanceled ?? false);
  bool get isCancelledStatus => isCanceled ?? false;

  String get status {
    if (isCancelledStatus) return 'canceled';
    if (isUsed) return 'used';
    return 'active';
  }

  // Short code for display (last 12 chars)
  String get shortCode {
    if (code == null || code!.isEmpty) return '-';
    return code!.length > 20
        ? '...${code!.substring(code!.length - 12)}'
        : code!;
  }
}
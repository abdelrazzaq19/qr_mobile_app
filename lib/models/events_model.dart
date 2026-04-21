import 'dart:convert';

Event eventFromJson(String str) => Event.fromJson(json.decode(str));
String eventToJson(Event data) => json.encode(data.toJson());

class Event {
  String? id;
  String? name;
  String? desc;
  List<String>? images;
  DateTime? date;
  int? maxReservation;
  int? ticketsCount; // dari withCount('tickets')
  DateTime? createdAt;
  DateTime? updatedAt;

  Event({
    this.id,
    this.name,
    this.desc,
    this.images,
    this.date,
    this.maxReservation,
    this.ticketsCount,
    this.createdAt,
    this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["id"],
    name: json["name"],
    desc: json["desc"],
    images: json["images"] == null
        ? []
        : List<String>.from(json["images"].map((x) => x.toString())),
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    maxReservation: json["max_reservation"] == null
        ? 0
        : int.tryParse(json["max_reservation"].toString()) ?? 0,

    ticketsCount: json["tickets_count"] == null
        ? 0
        : int.tryParse(json["tickets_count"].toString()) ?? 0,

    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "desc": desc,
    "images": images ?? [],
    "date": date?.toIso8601String(),
    "max_reservation": maxReservation,
    "tickets_count": ticketsCount,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

  // Status berdasarkan tanggal & kapasitas
  bool get isPast => date != null && date!.isBefore(DateTime.now());
  bool get isFull =>
      maxReservation != null &&
      ticketsCount != null &&
      ticketsCount! >= maxReservation!;

  String get status {
    if (isPast) return 'completed';
    if (isFull) return 'full';
    return 'active';
  }

  // Progress scan/reservasi
  double get progress {
    if (maxReservation == null || maxReservation! <= 0) return 0.0;
    return (ticketsCount ?? 0) / maxReservation!;
  }
}

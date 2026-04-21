// lib/controllers/events_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:qr_app/models/events_model.dart';
import 'package:qr_app/providers/events_provider.dart';
import 'package:qr_app/utils/show_snack.dart';

class EventsController extends GetxController {
  final EventProvider eventProvider = Get.put(EventProvider());
  final ImagePicker _picker = ImagePicker();

  // ── State ─────────────────────────────────────────────────────
  RxBool isLoadingEvents = false.obs;
  RxBool isSubmitting = false.obs;
  RxList<Event> events = <Event>[].obs;
  RxList<File> selectedImages = <File>[].obs;

  // ── Computed Stats ─────────────────────────────────────────────
  int get totalEvents => events.length;
  int get totalTicketsSold =>
      events.fold(0, (sum, e) => sum + (e.ticketsCount ?? 0));
  int get totalCapacity =>
      events.fold(0, (sum, e) => sum + (e.maxReservation ?? 0));

  // ── Form Keys ─────────────────────────────────────────────────
  final GlobalKey<FormState> createFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> editFormKey = GlobalKey<FormState>();

  // ── Form Controllers ──────────────────────────────────────────
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final dateController = TextEditingController();
  final maxReservationController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  @override
  void onClose() {
    nameController.dispose();
    descController.dispose();
    dateController.dispose();
    maxReservationController.dispose();
    super.onClose();
  }

  // ── Clear / Fill Form ─────────────────────────────────────────
  void clearForm() {
    nameController.clear();
    descController.clear();
    dateController.clear();
    maxReservationController.clear();
    selectedImages.clear();
  }

  void fillForm(Event event) {
    nameController.text = event.name ?? '';
    descController.text = event.desc ?? '';
    dateController.text = event.date != null
        ? DateFormat('yyyy-MM-dd').format(event.date!)
        : '';
    maxReservationController.text = event.maxReservation?.toString() ?? '';
    selectedImages.clear();
  }

  // ── Pick Images ───────────────────────────────────────────────
  Future<void> pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        selectedImages.addAll(images.map((xFile) => File(xFile.path)));
      }
    } catch (e) {
      ShowSnack.error('Error picking images: $e');
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  // ── Fetch All Events ──────────────────────────────────────────
  Future<void> fetchEvents() async {
    isLoadingEvents(true);
    try {
      final res = await eventProvider.getEvents();
      if (res.isOk) {
        final List data = res.body['data'] ?? [];
        events.value = data.map((e) => Event.fromJson(e)).toList();
      } else {
        throw res.body['message'] ?? 'Failed to load events';
      }
    } catch (e) {
      ShowSnack.error(e.toString());
    } finally {
      isLoadingEvents(false);
    }
  }

  // ── Create Event ──────────────────────────────────────────────
  Future<void> createEvent() async {
    if (!createFormKey.currentState!.validate()) return;

    isSubmitting(true);
    try {
      final res = await eventProvider.createEvent(
        name: nameController.text.trim(),
        desc: descController.text.trim(),
        date: dateController.text.trim(),
        maxReservation: int.tryParse(maxReservationController.text.trim()) ?? 0,
        images: selectedImages.isNotEmpty ? selectedImages : null,
      );

      if (res.isOk) {
        ShowSnack.success('Event created successfully');
        Get.back();
        clearForm();
        await fetchEvents();
      } else {
        final errors = res.body['errors'];
        if (errors is Map) throw errors.values.first[0];
        throw res.body['message'] ?? 'Failed to create event';
      }
    } catch (e) {
      ShowSnack.error(e.toString());
    } finally {
      isSubmitting(false);
    }
  }

  // ── Update Event ──────────────────────────────────────────────
  Future<void> updateEvent(String id) async {
    if (!editFormKey.currentState!.validate()) return;

    isSubmitting(true);
    try {
      final res = await eventProvider.updateEvent(
        id: id,
        name: nameController.text.trim(),
        desc: descController.text.trim(),
        date: dateController.text.trim(),
        maxReservation: int.tryParse(maxReservationController.text.trim()) ?? 0,
        images: selectedImages.isNotEmpty ? selectedImages : null,
      );

      if (res.isOk) {
        ShowSnack.success('Event updated successfully');
        Get.back();
        clearForm();
        await fetchEvents();
      } else {
        final errors = res.body['errors'];
        if (errors is Map) throw errors.values.first[0];
        throw res.body['message'] ?? 'Failed to update event';
      }
    } catch (e) {
      ShowSnack.error(e.toString());
    } finally {
      isSubmitting(false);
    }
  }

  // ── Delete Event ──────────────────────────────────────────────
  Future<void> deleteEvent(String id) async {
    try {
      final res = await eventProvider.deleteEvent(id);
      if (res.isOk) {
        ShowSnack.success('Event deleted');
        events.removeWhere((e) => e.id == id);
      } else {
        throw res.body['message'] ?? 'Failed to delete event';
      }
    } catch (e) {
      ShowSnack.error(e.toString());
    }
  }

  // ── Pick Date ─────────────────────────────────────────────────
  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFF97316),
            onPrimary: Colors.white,
            surface: Color(0xFF1A1A1A),
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  // ── Show Create Sheet ─────────────────────────────────────────
  void showCreateSheet(BuildContext context) {
    clearForm();
    _showEventFormSheet(context, isEdit: false);
  }

  // ── Show Edit Sheet ───────────────────────────────────────────
  void showEditSheet(BuildContext context, Event event) {
    fillForm(event);
    _showEventFormSheet(context, isEdit: true, event: event);
  }

  // ── Show Delete Dialog ────────────────────────────────────────
  void showDeleteDialog(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Event',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to delete "${event.name}"?\nThis action cannot be undone.',
          style: const TextStyle(color: Color(0xFF888888)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF888888)),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              deleteEvent(event.id!);
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Color(0xFFE05555),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Internal: Form Bottom Sheet ───────────────────────────────
  void _showEventFormSheet(
    BuildContext context, {
    required bool isEdit,
    Event? event,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A1A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Form(
            key: isEdit ? editFormKey : createFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isEdit ? 'Edit Event' : 'Create New Event',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Event Name
                  _field(
                    controller: nameController,
                    label: 'Event Name',
                    hint: 'e.g. Tech Conference 2026',
                    icon: Icons.title_rounded,
                    validator: (v) =>
                        v!.trim().isEmpty ? 'Name is required' : null,
                  ),
                  const SizedBox(height: 14),

                  // Description
                  _field(
                    controller: descController,
                    label: 'Description',
                    hint: 'Brief description about the event',
                    icon: Icons.description_outlined,
                    maxLines: 3,
                    validator: (v) =>
                        v!.trim().isEmpty ? 'Description is required' : null,
                  ),
                  const SizedBox(height: 14),

                  // Date
                  TextFormField(
                    controller: dateController,
                    readOnly: true,
                    onTap: () => pickDate(context),
                    validator: (v) =>
                        v!.trim().isEmpty ? 'Date is required' : null,
                    style: const TextStyle(color: Colors.white),
                    decoration: _deco(
                      label: 'Event Date',
                      hint: 'Select date',
                      icon: Icons.calendar_today_rounded,
                      suffix: const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Max Reservation
                  _field(
                    controller: maxReservationController,
                    label: 'Max Reservation',
                    hint: 'e.g. 200',
                    icon: Icons.confirmation_num_outlined,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v!.trim().isEmpty) return 'Required';
                      final n = int.tryParse(v.trim());
                      if (n == null) return 'Must be a number';
                      if (n < 1) return 'Must be at least 1';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Images Section
                  Row(
                    children: [
                      const Text(
                        'Event Images',
                        style: TextStyle(
                          color: Color(0xFF888888),
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: pickImages,
                        icon: const Icon(
                          Icons.add_photo_alternate_outlined,
                          color: Color(0xFFF97316),
                          size: 18,
                        ),
                        label: const Text(
                          'Add Images',
                          style: TextStyle(
                            color: Color(0xFFF97316),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Image Preview
                  Obx(
                    () => selectedImages.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFF222222),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF2A2A2A),
                              ),
                            ),
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  color: Color(0xFF555555),
                                  size: 32,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'No images selected',
                                  style: TextStyle(
                                    color: Color(0xFF555555),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: selectedImages.length,
                              itemBuilder: (ctx, index) {
                                return Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: FileImage(
                                            selectedImages[index],
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 12,
                                      child: GestureDetector(
                                        onTap: () => removeImage(index),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFE05555),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),

                  // Submit
                  Obx(
                    () => SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isSubmitting.value
                            ? null
                            : () => isEdit
                                  ? updateEvent(event!.id!)
                                  : createEvent(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF97316),
                          disabledBackgroundColor: const Color(
                            0xFFF97316,
                          ).withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: isSubmitting.value
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                isEdit ? 'Save Changes' : 'Create Event',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: _deco(label: label, hint: hint, icon: icon),
    );
  }

  InputDecoration _deco({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Color(0xFF888888)),
      hintStyle: const TextStyle(color: Color(0xFF555555)),
      prefixIcon: Icon(icon, color: const Color(0xFF888888), size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFF222222),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFF97316), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE05555)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE05555), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

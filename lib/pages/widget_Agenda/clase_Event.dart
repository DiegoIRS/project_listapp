class Event {
  final String title;
  final DateTime dateTime;
  final String status; // Añade este campo

  Event({required this.title, required this.dateTime, this.status = ''});
}

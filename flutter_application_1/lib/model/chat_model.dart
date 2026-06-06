enum MessageType {
  text,
  image,
  offerPending,
  offerAccepted,
}

class MessageModel {
  final String? text;
  final String? imagePath;
  final bool isMe;
  final String time;
  final MessageType type; // Tetap non-nullable

  // Properti opsional untuk fitur tawar-menawar buku
  final String? bookTitle;
  final String? author;
  final String? cover;
  final String? price;

  MessageModel({
    this.text,
    this.imagePath,
    this.bookTitle,
    this.author,
    this.cover,
    this.price,
    this.type = MessageType.text, // Sekarang aman menjadi default value
    required this.isMe,
    required this.time,
  });
}
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

ImageProvider getImageProvider(String urlOrBase64) {
  final cleanString = urlOrBase64.trim();
  if (cleanString.startsWith('data:image') || !cleanString.startsWith('http')) {
    try {
      String base64Str = cleanString;
      if (cleanString.contains(',')) {
        base64Str = cleanString.split(',').last;
      }
      final Uint8List bytes = base64Decode(base64Str.trim());
      return MemoryImage(bytes);
    } catch (e) {
      // Fallback placeholder image
      return const NetworkImage('https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=600&auto=format&fit=crop');
    }
  }
  return NetworkImage(cleanString);
}

Widget buildProductImage(String urlOrBase64, {BoxFit fit = BoxFit.cover, double? width, double? height}) {
  final cleanString = urlOrBase64.trim();
  if (cleanString.startsWith('data:image') || !cleanString.startsWith('http')) {
    try {
      String base64Str = cleanString;
      if (cleanString.contains(',')) {
        base64Str = cleanString.split(',').last;
      }
      final Uint8List bytes = base64Decode(base64Str.trim());
      return Image.memory(
        bytes,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          return Image.network(
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=600&auto=format&fit=crop',
            fit: fit,
            width: width,
            height: height,
          );
        },
      );
    } catch (e) {
      // Fallback
    }
  }
  return Image.network(
    cleanString,
    fit: fit,
    width: width,
    height: height,
    errorBuilder: (context, error, stackTrace) {
      return Image.network(
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=600&auto=format&fit=crop',
        fit: fit,
        width: width,
        height: height,
      );
    },
  );
}

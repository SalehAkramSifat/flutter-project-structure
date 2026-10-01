import 'dart:io';
import 'package:flutter_project_structure/core/common/app_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PdfDownloader {
  PdfDownloader._();

  static Future<File?> downloadPdf(String url, {String? title}) async {
    try {
      final cleanTitle = (title ?? 'document')
          .replaceAll(RegExp(r'[^\w\s\.-]'), '_')
          .trim();
      final fileName = cleanTitle.endsWith('.pdf')
          ? cleanTitle
          : '$cleanTitle.pdf';

      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        AppSnackBar.showError('Could not access storage directory');
        return null;
      }

      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        AppSnackBar.showSuccess('PDF downloaded successfully: $fileName');
        return file;
      } else {
        AppSnackBar.showError(
          'Download failed (Status: ${response.statusCode})',
        );
        return null;
      }
    } catch (e) {
      AppSnackBar.showError('Failed to download PDF: $e');
      return null;
    }
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/features/profil/presentation/provider/profile.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<void> generateCard({
  required BuildContext context,
  required ProfileProvider pp,
}) async {
  PdfDocument document = PdfDocument();

  final page = document.pages.add();

  final Size pageSize = page.getClientSize();

  page.graphics.drawImage(PdfBitmap(await pp.readImageData('ic-card-back.png')),
      Rect.fromLTWH(0, 0, pageSize.width, 300));
  page.graphics.drawImage(PdfBitmap(await pp.readImageData('ic-card-new.png')),
      Rect.fromLTWH(0, 350, pageSize.width, 300));

  page.graphics.drawString(
    context.read<ProfileProvider>().pd.fullname!.toUpperCase(),
    PdfStandardFont(PdfFontFamily.helvetica, Dimensions.fontSizeSmall,
        style: PdfFontStyle.bold),
    bounds: Rect.fromLTWH(240, 440, 250, pageSize.height),
    format: PdfStringFormat(
        wordWrap: PdfWordWrapType.word, alignment: PdfTextAlignment.center),
    brush: PdfBrushes.white,
  );
  context.read<ProfileProvider>().pd.country!.name != "Indonesia"
      ? page.graphics.drawString(
          '${context.read<ProfileProvider>().pd.position!.toUpperCase()} PPI ${context.read<ProfileProvider>().pd.country!.name?.toUpperCase() ?? "-"}',
          PdfStandardFont(PdfFontFamily.helvetica, Dimensions.fontSizeSmall),
          bounds: const Rect.fromLTWH(240, 460, 250, 300),
          format: PdfStringFormat(
            wordWrap: PdfWordWrapType.word,
            alignment: PdfTextAlignment.center,
          ),
          brush: PdfBrushes.white,
        )
      : const SizedBox();

  page.graphics.drawString(
    context.read<ProfileProvider>().pd.email!,
    PdfStandardFont(PdfFontFamily.helvetica, 15, style: PdfFontStyle.bold),
    bounds: Rect.fromLTWH(270, 570, pageSize.width, pageSize.height),
    format: PdfStringFormat(),
    brush: PdfBrushes.white,
  );
  page.graphics.drawString(
    context.read<ProfileProvider>().pd.phone!,
    PdfStandardFont(PdfFontFamily.helvetica, 15, style: PdfFontStyle.bold),
    bounds: Rect.fromLTWH(270, 595, pageSize.width, pageSize.height),
    format: PdfStringFormat(),
    brush: PdfBrushes.white,
  );

  final List<int> bytes = document.saveSync();
  document.dispose();

  await pp.saveAndLaunchFile(bytes,
      'kartu-anggota-ppi-${context.read<ProfileProvider>().pd.fullname!.replaceAll(" ", "-").toLowerCase()}.pdf');
}

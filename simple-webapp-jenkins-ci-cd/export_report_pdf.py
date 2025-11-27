import os
from win32com.client import Dispatch

ROOT = os.path.dirname(__file__)
DOCX = os.path.join(ROOT, 'project_report.docx')
PDF = os.path.join(ROOT, 'project_report.pdf')

ppSaveAsPDF = 17  # Word constant (WdExportFormatPDF via ExportAsFixedFormat is preferred; using SaveAs2 here)


def export_pdf(docx_path, pdf_path):
    app = Dispatch('Word.Application')
    app.Visible = False
    doc = app.Documents.Open(docx_path)
    # Use ExportAsFixedFormat when available
    try:
        wdExportFormatPDF = 17
        doc.ExportAsFixedFormat(OutputFileName=pdf_path, ExportFormat=wdExportFormatPDF)
    except Exception:
        # Fallback to SaveAs2 with format 17
        doc.SaveAs2(pdf_path, FileFormat=17)
    finally:
        doc.Close(False)
        app.Quit()


def main():
    if not os.path.exists(DOCX):
        print('Missing:', DOCX)
        return
    export_pdf(DOCX, PDF)
    print('Exported:', PDF)


if __name__ == '__main__':
    main()

import os
import time
from win32com.client import Dispatch

ROOT = os.getcwd()
FILES = [
    (os.path.join(ROOT, 'project_presentation.pptx'), os.path.join(ROOT, 'project_presentation.pdf')),
    (os.path.join(ROOT, 'project_presentation_short.pptx'), os.path.join(ROOT, 'project_presentation_short.pdf')),
]

ppFixedFormatTypePDF = 2  # ExportAsFixedFormat const (unused now)
ppSaveAsPDF = 32


def export_pdf(in_pptx, out_pdf):
    print(f"Exporting {os.path.basename(in_pptx)} → {os.path.basename(out_pdf)}")
    app = Dispatch('PowerPoint.Application')
    app.Visible = True
    pres = app.Presentations.Open(in_pptx, WithWindow=False)
    # Use ExportAsFixedFormat for PDF to avoid incorrect SaveAs formats
    # Use SaveAs with ppSaveAsPDF (32)
    pres.SaveAs(out_pdf, ppSaveAsPDF)
    pres.Close()
    app.Quit()


def main():
    for pptx_path, pdf_path in FILES:
        if os.path.exists(pptx_path):
            export_pdf(pptx_path, pdf_path)
        else:
            print(f"Skip (missing): {pptx_path}")
    print("Done.")


if __name__ == '__main__':
    main()

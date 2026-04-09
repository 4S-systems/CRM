package com.maintenance.common;

import com.lowagie.text.Element;
import com.lowagie.text.Paragraph;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.maintenance.db_access.MaintenanceItemMgr;
import com.maintenance.db_access.UnitScheduleMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.UserMgr;
import com.tracker.db_access.IssueMgr;
import java.awt.BasicStroke;
import java.awt.image.ImageObserver;
import java.io.FileOutputStream;

import com.lowagie.text.Document;
import com.lowagie.text.PageSize;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Vector;
import javax.swing.ImageIcon;

/**
 * Draws arabic text using java.awt.Graphics2D
 */
public class PDFTextCreator implements ImageObserver {

    String[] itemAtt = {"note", "itemId", "itemQuantity", "itemPrice", "totalCost"};

    public PDFTextCreator(String issueID, Vector itemList, String realPath, String userID) {
        // step 1
        Document document = new Document(PageSize.A4, 50, 50, 50, 50);
        BasicStroke stroke = new BasicStroke(1.0f);
        UserMgr userMgr = UserMgr.getInstance();
        WebBusinessObject wbo = IssueMgr.getInstance().getOnSingleKey(issueID);
        WebBusinessObject wboTemp = UnitScheduleMgr.getInstance().getOnSingleKey(wbo.getAttribute("unitScheduleID").toString());
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        try {
            ImageIcon icon = new ImageIcon(realPath + "\\lehaaLogo.JPG");
            // step 2
            PdfWriter writer = PdfWriter.getInstance(document, new FileOutputStream(realPath + "\\u" + userID + ".pdf"));

            // step 3
            document.open();
            // step 4
            String text1 = "\u0634\u0631\u0643\u0629 \u0644\u062d\u0627\u0621 \u0644\u0644\u062a\u062c\u0627\u0631\u0629 \u0648\u0627\u0644\u0627\u0633\u062a\u062b\u0645\u0627\u0631 \u0627\u0644\u0632\u0631\u0627\u0639\u064a \u0634.\u0645.\u0645";
            java.awt.Font font = new java.awt.Font("arial", 0, 18);
            PdfContentByte cb = writer.getDirectContent();
            java.awt.Graphics2D g2 = cb.createGraphicsShapes(PageSize.A4.getWidth(), PageSize.A4.getHeight());
            g2.setFont(font);
            g2.drawImage(icon.getImage(), 50, 30, 53, 60, (ImageObserver) this);
            g2.drawString(text1, 270, 50);
            g2.dispose();
            text1 = new String("Lehaa for Trading and Agricultural Investment S.A.E");
            Paragraph p = new Paragraph(text1);
            p.setAlignment(Element.ALIGN_RIGHT);
            document.add(p);
            text1 = new String("Job Order");
            p = new Paragraph(text1);
            p.setAlignment(Element.ALIGN_CENTER);
            p.setSpacingBefore(100.0f);
            document.add(p);
            Calendar c = Calendar.getInstance();
            SimpleDateFormat f = new SimpleDateFormat("yyyy / MM / dd ");
            text1 = new String(" Date  " + f.format(c.getTime()).toString());
            p = new Paragraph(text1);
            p.setAlignment(Element.ALIGN_LEFT);
            p.setSpacingBefore(35.0f);
            document.add(p);
            PdfPTable table = new PdfPTable(3);
            table.setSpacingBefore(20.0f);
            table.addCell("Site (Place of Maintenance)");
            table.addCell(" : ");
            table.addCell("site1");
            int[] widths = {60, 4, 80};
            table.addCell("Equipment Name");
            table.addCell(" : ");
            table.addCell("new sub unit");

            table.addCell("Description");
            table.addCell(" : ");
            table.addCell(wbo.getAttribute("issueDesc").toString());
            table.setWidths(widths);
            document.add(table);

            text1 = new String("List of Items");
            p = new Paragraph(text1);
            p.setAlignment(Element.ALIGN_CENTER);
            p.setSpacingBefore(50.0f);
            document.add(p);
            PdfPCell cell = new PdfPCell(new Paragraph("No."));
            cell.setHorizontalAlignment(1);
            table = new PdfPTable(5);
            table.setWidthPercentage(100.0f);
            table.setSpacingBefore(25.0f);
            int[] widths2 = {10, 30, 30, 30, 60};
            table.setWidths(widths2);
            table.setHeaderRows(0);
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("Item Number"));
            cell.setHorizontalAlignment(1);
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("Item Name"));
            cell.setHorizontalAlignment(1);
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("Quantity"));
            cell.setHorizontalAlignment(1);
            table.addCell(cell);
            cell = new PdfPCell(new Paragraph("Note"));
            cell.setHorizontalAlignment(1);
            table.addCell(cell);
            MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
            for (int i = 0; i < itemList.size(); i++) {
                cell = new PdfPCell(new Paragraph(new Integer(i + 1).toString()));
                cell.setHorizontalAlignment(1);
                table.addCell(cell);
                wbo = (WebBusinessObject) itemList.get(i);
                WebBusinessObject wboT = maintenanceItemMgr.getOnSingleKey(wbo.getAttribute(itemAtt[1]).toString());
                cell = new PdfPCell(new Paragraph(wboT.getAttribute("itemCode").toString()));
                cell.setHorizontalAlignment(0);
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph(wboT.getAttribute("itemDscrptn").toString()));
                cell.setHorizontalAlignment(0);
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph(wbo.getAttribute(itemAtt[2]).toString()));
                cell.setHorizontalAlignment(0);
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph(wbo.getAttribute(itemAtt[0]).toString()));
                cell.setHorizontalAlignment(0);
                table.addCell(cell);
            }
            document.add(table);
            // step 5
            document.close();
        } catch (Exception de) {

        }
    }

    /**
     * Draws arabic text using java.awt.Graphics2D.
     * @param args no arguments needed
     */
//    public static void main(String[] args) {
//        new PDFTextCreator();
//    }
    public boolean imageUpdate(java.awt.Image img, int infoflags, int x, int y, int width, int height) {
        return true;
    }
}

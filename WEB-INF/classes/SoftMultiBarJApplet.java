import ChartDirector.BarLayer;
import ChartDirector.Chart;
import ChartDirector.ChartViewer;
import ChartDirector.XYChart;
/*
 * SmallSecPieJApplet.java
 *
 * Created on August 7, 2006, 12:47 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

/**
 *
 * @author image
 */
public class SoftMultiBarJApplet extends javax.swing.JApplet {
    
    //Name of demo program
    public String toString() { return "Soft Multi-Bar Chart"; }

    //Number of charts produced in this demo
    public int getNoOfCharts() { return 1; }

    //Main code for creating charts
    public void createChart(ChartViewer viewer, int index)
    {
        // The data for the bar chart
//        double[] data0 = {100, 125, 245, 147, 67};
        String[] sData0 = getParameter("Total").split(" ");
        double[] data0 = new double[sData0.length];//{15, 6, 1, 1, 4, 1, 3, 17};
        for(int i = 0; i < data0.length; i++){
            data0[i] = new Double(sData0[i]).doubleValue();
        }
//        double[] data1 = {85, 156, 179, 211, 123};
        String[] sData1 = getParameter("Finished").split(" ");
        double[] data1 = new double[sData1.length];//{15, 6, 1, 1, 4, 1, 3, 17};
        for(int i = 0; i < data1.length; i++){
            data1[i] = new Double(sData1[i]).doubleValue();
        }
//        String[] labels = {"Mon", "Tue", "Wed", "Thur", "Fri"};
        String[] labels = getParameter("labels").split(" ");

        // Create a XYChart object of size 540 x 375 pixels
        XYChart c = new XYChart(540, 375);

        // Add a title to the chart using 18 pts Times Bold Italic font
        c.addTitle("Ratio Successed for the Plan", "Times New Roman Bold Italic", 18);

        // Set the plotarea at (50, 55) and of 440 x 280 pixels in size. Use a
        // vertical gradient color from light red (ffdddd) to dark red (880000) as
        // background. Set border and grid lines to white (ffffff).
        c.setPlotArea(50, 55, 440, 280, c.linearGradientColor(0, 55, 0, 335,
            0xffdddd, 0x880000), -1, 0xffffff, 0xffffff);

        // Add a legend box at (50, 25) using horizontal layout. Use 10pts Arial Bold
        // as font, with transparent background.
        c.addLegend(50, 25, false, "Arial Bold", 10).setBackground(Chart.Transparent)
            ;

        // Set the x axis labels
        c.xAxis().setLabels(labels);

        // Draw the ticks between label positions (instead of at label positions)
        c.xAxis().setTickOffset(0.5);

        // Set axis label style to 8pts Arial Bold
        c.xAxis().setLabelStyle("Arial Bold", 8);
        c.yAxis().setLabelStyle("Arial Bold", 8);

        // Set axis line width to 2 pixels
        c.xAxis().setWidth(2);
        c.yAxis().setWidth(2);

        // Add axis title
        c.yAxis().setTitle("Job Order per Month");

        // Add a multi-bar layer with 3 data sets and 4 pixels 3D depth
        BarLayer layer = c.addBarLayer2(Chart.Side, 4);
        layer.addDataSet(data0, 0xffff00, "Total");
        layer.addDataSet(data1, 0x00ff00, "Finished");

        // Set bar border to transparent. Use soft lighting effect with light
        // direction from top.
        layer.setBorderColor(Chart.Transparent, Chart.softLighting(Chart.Top));

        // Configure the bars within a group to touch each others (no gap)
        layer.setBarGap(0.2, Chart.TouchBar);

        // output the chart
        viewer.setImage(c.makeImage());

        //include tool tip for the chart
        viewer.setImageMap(c.getHTMLImageMap("clickable", "",
            "title='{dataSetName} on {xLabel}: {value} Job Order/Month'"));
    }
    
    public void init() {
        ChartViewer viewer = new ChartViewer();
        createChart(viewer, 0);
        getContentPane().add(viewer);
    }
}

/*
 * ImageHandlerServlet.java
 *
 * Created on March 24, 2004, 6:03 AM
 */

package com.docviewer.servlets;

import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.silkworm.servlets.swBaseServlet;

import java.util.*;
import com.silkworm.business_objects.*;

import com.docviewer.db_access.ImageMgr;
import com.silkworm.servlets.MultipartRequest;


// import com.silkworm.common.TimeServices;
/**
 *
 * @author  walid
 * @version
 */
public class ImageHandlerServlet extends swBaseServlet {
    
    /** Initializes the servlet.
     */
    
    
    protected int operation = 0;
    
    String userName = null;
    
    String imageDirPath= null;
    String audioDirPath= null;
    
    String RIPath = null;
    String absPath = null;
    File docImage = null;
    ImageMgr imageMgr = ImageMgr.getInstance();
    protected MultipartRequest mpr = null;
    String web_inf_path = null;
    
    // make home directory for all user activities
    
    protected String userHome = null;
    protected String userImageDir = null;
    String userAudioDir = null;
    protected String userBackendHome = null;
    
    protected String estorage = null;
    protected String edatabase = null;
    
    
    
    
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        web_inf_path =   getServletContext().getRealPath("/WEB-INF");
        imageDirPath =   getServletContext().getRealPath("/images");
        audioDirPath =   getServletContext().getRealPath("/audio");
        
        
    }
    
    /** Destroys the servlet.
     */
    public void destroy() {
        
    }
    
    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
        super.processRequest(request,response);
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        
        System.out.println("Besmllah");
        session = request.getSession();
        if(null==session) {
            forward("/main.jsp",request,response);
        }
        
        loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        
        if(null==loggedUser) {
            forward("/main.jsp",request,response);
        } else {
            userHome = (String) loggedUser.getAttribute("userHome");
            userImageDir =  imageDirPath + "/" + userHome;
            userBackendHome = web_inf_path + "/usr/" + userHome + "/";
            //System.out.println("NEEE WWWWW PATH IS " + userImageDir);
        }
        
      
        
        
    }
    
    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    /** Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Base Servlet for handling image persistence";
    }
    
   
    
    protected void createEStorageDir() {
        
        estorage = web_inf_path + "/usr/estorage";
        File eStorageDir = new File(estorage);
        eStorageDir.mkdir();
        edatabase = estorage + "/";
        
    }
    
  
    
    protected void createUserAudioDir(String userName) {
        
        String path = new String(audioDirPath + "/" + userName);
        File audioDir = new File(path);
        
        if(audioDir.isDirectory()) {
            File[] list = audioDir.listFiles();
            for(int i =0;i<list.length;i++) {
                list[i].delete();
            }
        }
        
        audioDir.mkdir();
        userAudioDir = audioDirPath + "/" + userName;
    }
    
    
    
    
    protected int docCount() {
        
        return imageMgr.getCount();
    }
    
    
    protected void demoOnly(HttpServletRequest request, HttpServletResponse response) {
        
        request.setAttribute("message", "This is a Demo Version Only - can not save more than 20 documents");
        
        
    }
    protected void printFileNames() {
        Enumeration enum1 = mpr.getFileNames();
        while(enum1.hasMoreElements())
            System.out.println(mpr.getFilesystemName((String) enum1.nextElement()));
        
    }
    
    protected String getAudioPath(String sound) {
        
        FileInputStream from = null;  // Stream to read from source
        FileOutputStream to = null;   // Stream to write to destination
        try {
            
            
            File source = new File(edatabase + sound);
            File dest = new File(userAudioDir);
            
            
            if (dest.isDirectory())
                dest = new File(dest, source.getName());
            
            
            
            from = new FileInputStream(source);  // Create input stream
            to = new FileOutputStream(dest);     // Create output stream
            byte[] buffer = new byte[4096];         // To hold file contents
            int bytes_read;                         // How many bytes in buffer
            
            
            while((bytes_read = from.read(buffer)) != -1) // Read until EOF
                to.write(buffer, 0, bytes_read);            // write
            
            
            
            
            return "audio" + "/" + userName + "/" + dest.getName();
            
        } catch(IOException ioex) {
            
            ;
            
        } finally {
            if (from != null) try { from.close(); } catch (IOException e) { ; }
            if (to != null) try { to.close(); } catch (IOException e) { ; }
            
            
        }
        
        return null;
    }
    
    
//    protected String buildFromDate(HttpServletRequest theRequest) {
//        
//        System.out.println("Building from time stamp ");
//        DictionaryItem tsItem = null;
//        String[] timeStamp = new String[6];
//        String startMonth = (String) theRequest.getParameter("startMonth");
//        startMonth = new String(DateAndTimeConstants.getMonthAsNumberString(startMonth));
//        System.out.println("start month...." + startMonth);
//        
//        timeStamp[0] = new String((String) theRequest.getParameter("startYear"));
//        timeStamp[1] = new String(startMonth);
//        timeStamp[2] = new String((String) theRequest.getParameter("startDay"));
//        
//        timeStamp[3] = new String("00");
//        timeStamp[4] = new String("00");
//        timeStamp[5] = new String("00");
//        
//        
//        
//        
//        
//        return TimeServices.getDateAsLongString(timeStamp);
//    }
//    
//    protected String buildToDate(HttpServletRequest theRequest) {
//        System.out.println("Building to time stamp ");
//        DictionaryItem tsItem = null;
//        String[] timeStamp = new String[6];
//        String endMonth = (String) theRequest.getParameter("endMonth");
//        endMonth = new String(DateAndTimeConstants.getMonthAsNumberString(endMonth));
//        //System.out.println(" Building to time stamp .......................is");
//        
//        timeStamp[0] = new String((String) theRequest.getParameter("endYear"));
//        timeStamp[1] = new String(endMonth);
//        timeStamp[2] = new String((String) theRequest.getParameter("endDay"));
//        timeStamp[3] = new String("00");
//        timeStamp[4] = new String("00");
//        timeStamp[5] = new String("00");
//        
//        return TimeServices.getDateAsLongString(timeStamp);
//    }
//    
//    
    
}

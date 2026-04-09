/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.android;

import com.android.business_objects.LiteWebBusinessObject;
import com.android.db_access.AndroidDevicesMgr;
import com.android.exceptions.LiteUnsupportedTypeException;
import com.businessfw.hrs.db_access.EmployeeMgr;
import com.businessfw.hrs.servlets.EmployeeServlet;
import com.clients.db_access.ClientMgr;
import com.lowagie.text.pdf.codec.Base64;
import com.maintenance.common.Tools;
import com.maintenance.db_access.IssueDocumentMgr;
import com.maintenance.db_access.UnitDocMgr;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.EmpRelationMgr;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.db_access.FileMgr;
import com.silkworm.uploader.FileMeta;
import com.tracker.db_access.ProjectMgr;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.net.URLDecoder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author asteriskpbx
 */
public class CrmServlet extends HttpServlet
{

    private OutputStreamWriter out;
    int operation;
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    EmployeeMgr empMgr = EmployeeMgr.getInstance();
    IssueDocumentMgr docMgr = IssueDocumentMgr.getInstance();
    UnitDocMgr unitDocMgr = UnitDocMgr.getInstance();
    FileMgr fileMgr = FileMgr.getInstance();
    MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
    EmployeeMgr employeeMgr = EmployeeMgr.getInstance();
    ClientMgr clientMgr = ClientMgr.getInstance();
    AndroidDevicesMgr androidDeviceMgr = AndroidDevicesMgr.getInstance();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        response.setContentType("text/html;charset=UTF-8");
        operation = getOpCode((String) request.getParameter("op"));
        switch (operation)
        {
            case 1:
            {
                MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
                out = new OutputStreamWriter(response.getOutputStream());
                String bitmap = request.getParameter("bitmap");
                String fileName = request.getParameter("fileName");
                String unitId = request.getParameter("entityId");
                byte[] decodedBitmap = Base64.decode(bitmap);
                try
                {
                    String documentExtension = fileName.substring(fileName.indexOf(".") + 1, fileName.length());
                    WebBusinessObject fileDescriptor = fileDescriptor = fileMgr.getObjectFromCash(documentExtension);
                    String metaType = (String) fileDescriptor.getAttribute("metaType");
                    FileMeta fileMeta = new FileMeta();
                    fileMeta.setFileName(fileName);
                    fileMeta.setFileType(metaType);
                    InputStream targetStream = new ByteArrayInputStream(decodedBitmap);
                    fileMeta.setContent(targetStream);
                    fileMeta.setFileSize(targetStream.available());
                    List<FileMeta> files = new ArrayList<>();
                    files.add(fileMeta);
                    //boolean result = unitDocMgr.saveAndroidImage(img, unitId);
                    boolean result2 = docMgr.saveDocuments(files, unitId, "employee", "1", metaType);
                }
                catch (IOException ex)
                {
                    ex.printStackTrace();
                }
                out.write("success");
                out.close();
                break;
            }
            case 2:
            {
                String empNumber = URLDecoder.decode(request.getParameter("empNumber"), "UTF-8");
                LiteWebBusinessObject unitWebo = null;
                try
                {
                    unitWebo = (LiteWebBusinessObject) empMgr.getOnArbitraryKey(empNumber, "key2").get(0);
                }
                catch (Exception ex)
                {
                    Logger.getLogger(QRServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                out = new OutputStreamWriter(response.getOutputStream());
                out.write(Tools.getJSONObjectAsString(unitWebo));
                out.close();
                break;
            }
            case 3:
            {
                out = new OutputStreamWriter(response.getOutputStream());
                String searchBy = request.getParameter("searchBy");
                String searchValue = request.getParameter("searchByValue");
                //searchByValue = null;
                //clientStatusVec = null;
                String status = " ";
                String check = "check";
                Vector unitsVec = new Vector();
                projectMgr = ProjectMgr.getInstance();
                if (searchBy != null && searchValue != null)
                {
                    try
                    {
                        request.setAttribute("searchValue", searchValue);
                        EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
                        WebBusinessObject managerWbo = empRelationMgr.getOnSingleKey("key2", "1");
                        WebBusinessObject departmentWbo;

                        unitsVec = projectMgr.getUnitsFromProject(searchValue, null, null, null);
                    }
                    catch (NoUserInSessionException ex)
                    {
                        ex.printStackTrace();
                    }
                    out.write(Tools.getJSONArrayAsString2(unitsVec));
                    out.close();
                }
                break;
            }
            case 4:
            {
                MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
                out = new OutputStreamWriter(response.getOutputStream(), "UTF-8");
                String bitmap = request.getParameter("bitmap");
                String fileName = request.getParameter("fileName");
                String projectId = request.getParameter("entityId");
                FileOutputStream stream = new FileOutputStream(metaDataMgr.getWebDirectoryPath() + fileName);
                byte[] decodedBitmap = Base64.decode(bitmap);
                try
                {
                    stream.write(decodedBitmap);
                }
                catch (IOException ex)
                {
                    ex.printStackTrace();
                }
                finally
                {
                    stream.close();
                }
                try
                {
                    boolean result = unitDocMgr.saveUnitImageFromAndroid(new File(metaDataMgr.getWebDirectoryPath() + fileName), projectId);
                }
                catch (NoUserInSessionException ex)
                {
                    Logger.getLogger(CrmServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                catch (SQLException ex)
                {
                    Logger.getLogger(CrmServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                //boolean result2 = docMgr.saveDocuments(files, projectId, "project", "1", metaType);
                out.write("success");
                out.close();
                break;
            }
            case 5:
            {
                out = new OutputStreamWriter(response.getOutputStream());
                String empNo = request.getParameter("empNo");
                List<LiteWebBusinessObject> Employees = new ArrayList<>();
                try
                {
                    Employees = employeeMgr.filterItems(empNo);
                }
                catch (LiteUnsupportedTypeException ex)
                {
                    Logger.getLogger(EmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                catch (Exception ex)
                {
                    Logger.getLogger(CrmServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                out = new OutputStreamWriter(response.getOutputStream());
                out.write(Tools.getLiteJSONArrayAsString(Employees));
                out.close();
                break;
            }
            case 6:
            {
                String mobile = request.getParameter("mobile").trim();
                WebBusinessObject client = clientMgr.getOnSingleKey("key4", mobile);
                out = new OutputStreamWriter(response.getOutputStream());
                if (client != null)
                {
                    out.write(Tools.getJSONObjectAsString(client));
                }
                else
                {
                    out.write("");
                }
                out.close();
                break;
            }
            case 7:
            {
                out = new OutputStreamWriter(response.getOutputStream());
                String mac = request.getParameter("mac");
                String result = androidDeviceMgr.RegesterDivce(mac);
                out.write(result);
                out.close();
                break;
            }
            case 8:
            {
                out = new OutputStreamWriter(response.getOutputStream());
                String clientName = request.getParameter("name");
                String clientNumber = request.getParameter("number");
                String result="";
                try
                {
                    result = clientMgr.saveClient(clientName,clientNumber);
                }
                catch (NoUserInSessionException ex)
                {
                    Logger.getLogger(CrmServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                catch (InterruptedException ex)
                {
                    Logger.getLogger(CrmServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                out.write(result);
                out.close();
                break;
            }
            case 9:
            {
                MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
                out = new OutputStreamWriter(response.getOutputStream());
                String bitmap = request.getParameter("bitmap");
                String fileName = request.getParameter("fileName");
                String unitId = request.getParameter("entityId");
                byte[] decodedBitmap = Base64.decode(bitmap);
                try
                {
                    String documentExtension = fileName.substring(fileName.indexOf(".") + 1, fileName.length());
                    WebBusinessObject fileDescriptor = fileDescriptor = fileMgr.getObjectFromCash(documentExtension);
                    String metaType = (String) fileDescriptor.getAttribute("metaType");
                    FileMeta fileMeta = new FileMeta();
                    fileMeta.setFileName(fileName);
                    fileMeta.setFileType(metaType);
                    InputStream targetStream = new ByteArrayInputStream(decodedBitmap);
                    fileMeta.setContent(targetStream);
                    fileMeta.setFileSize(targetStream.available());
                    List<FileMeta> files = new ArrayList<>();
                    files.add(fileMeta);
                    //boolean result = unitDocMgr.saveAndroidImage(img, unitId);
                    boolean result2 = docMgr.saveDocuments(files, unitId, "client", "1", metaType);
                }
                catch (IOException ex)
                {
                    ex.printStackTrace();
                }
                out.write("success");
                out.close();
                break;
            }
        }
    }

    protected int getOpCode(String opName)
    {
        if (opName.equals("uploadEmployeeImage"))
        {
            return 1;
        }
        if (opName.equals("getEmpByEmpNumber"))
        {
            return 2;
        }
        if (opName.equals("serarchForUnitByCode"))
        {
            return 3;
        }
        if (opName.equals("uploadUnitImage"))
        {
            return 4;
        }
        if (opName.equals("getEmployees"))
        {
            return 5;
        }
        if (opName.equals("getClient"))
        {
            return 6;
        }
        if (opName.equals("registerDevice"))
        {
            return 7;
        }
        if (opName.equals("addClient"))
        {
            return 8;
        }if (opName.equals("uploadClientImage"))
        {
            return 9;
        }
        return 0;
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo()
    {
        return "Short description";
    }// </editor-fold>

}

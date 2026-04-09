/*
 * Document.java
 *
 * Created on April 7, 2004, 5:55 PM
 */

package com.docviewer.business_objects;

import com.docviewer.servlets.ConfigurationServlet;
import com.silkworm.business_objects.WebBusinessObject;
import java.util.*;
import java.math.*;
import java.io.Serializable;

import com.silkworm.common.*;
import com.silkworm.international.TouristGuide;
import com.silkworm.db_access.FileMgr;
import com.docviewer.db_access.ImageMgr;
import com.docviewer.db_access.DocTypeMgr;
/**
 *
 * @author  walid
 */
public  class Document extends WebBusinessObject implements Serializable{
    
    /** Creates a new instance of Document */
    
    private WebBusinessObject bookMark = null;
    // private WebBusinessObject baseLine = null;
    protected String docType = null;
    
    protected String context = null;
    // ---------- owenership
    private String ownerId = null;
    private String sysUserId = null;
    private boolean isUserOwner = false;
    private String denyStateAccess = null;
    
    private TouristGuide tGuide = null;
    protected String targetServlet = null;
    protected String configType = null ;
    private FileMgr fileMgr = FileMgr.getInstance();
    private ImageMgr imgMgr = ImageMgr.getInstance();
    private boolean isMutipleImage = false;
    
    WebBusinessObject fileDescriptor = null;
    
    private Vector docImages = null;
    
    private Document parent = null;
    private String issueid =null;
    
    public Document(Hashtable ht) {
        super(ht);
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        tGuide = new TouristGuide("/com/docviewer/international/DocOnlineMenu");
        
        context= metaMgr.getContext();
        
        docType = (String) this.getAttribute("docType");
        fileDescriptor = fileMgr.getObjectFromCash(docType);
        
    }
    
    public Document(Document anotherDoc) {
        super((WebBusinessObject) anotherDoc);
        
    }
    public void setParentIssueId(String issueid) {
        
        this.issueid.equals(issueid);
    }
    
    public  String getParentIssueId() {
        
        return issueid;
    }
    
    
//    public void setViewOrigin(WebBusinessObject viewOrigin) {
//        this.viewOrigin = viewOrigin;
//
//    }
//
//    public WebBusinessObject getViewOrigin() {
//        return viewOrigin;
//    }
    
    public void setConfigType(String configType) {
        this.configType = configType;
        
    }
    
    public String getConfigType() {
        String configItemType = (String) getAttribute("configItemType");
        return configItemType;
    }
    
    public void setBookmark(WebBusinessObject bookMark) {
        this.bookMark = bookMark;
        
    }
    
    public void settargetServlet(String targetServlet) {
        this.targetServlet = targetServlet;
        
    }
    
    public String gettargetServlet() {
        return targetServlet;
    }
    
    public WebBusinessObject getBookMark() {
        return bookMark;
    }
    
    public boolean isBookmarked() {
        
        return (bookMark!=null?true:false);
    }
    
    public String getUndoBookmarkLink() {
        
        
        String filterValue = (String) viewOrigin.getAttribute("filterValue");
        // System.out.println("ARRR Filter Value" + filterValue);
        
        if(filterValue.indexOf("&")==0) {
            filterValue =  filterValue.replace('&','^');
            filterValue =  filterValue.replace('#','$');
        }
        
        return context + "/BookmarkServlet?op=RemoveBookmark&bookmarkId=" + (String) bookMark.getAttribute("bookmarkId") +
                "&filter=" + (String) viewOrigin.getAttribute("filter") + "&filterValue=" + filterValue + "&destServlet=" + "ImageReaderServlet";
    }
    
    public String getViewBookmarkLink() {
        
        String filterValue = (String) viewOrigin.getAttribute("filterValue");
        // System.out.println("ARRR Filter Value" + filterValue);
        
        if(filterValue.indexOf("&")==0) {
            filterValue =  filterValue.replace('&','^');
            filterValue =  filterValue.replace('#','$');
        }
        
        return context + "/BookmarkServlet?op=ViewBookmark&bookmarkId=" + (String) bookMark.getAttribute("bookmarkId") +
                "&filter=" + (String) viewOrigin.getAttribute("filter") + "&filterValue=" + filterValue;
        
    }
    
//    public boolean isBaselined() {
//
//        return (baseLine!=null?true:false);
//    }
    
    public String getDeleteLink() {
        String filterValue = (String) viewOrigin.getAttribute("filterValue");
        // System.out.println("ARRR Filter Value" + filterValue);
        
        if(filterValue.indexOf("&")==0) {
            filterValue =  filterValue.replace('&','^');
            filterValue =  filterValue.replace('#','$');
        }
        
        if(this.isUserOwner || webUserGroup.equalsIgnoreCase("Administrator")) {
            return context + "/ImageReaderServlet?op=ConfirmDelete&docId=" + (String) getAttribute("docID") + "&filter=" + (String) viewOrigin.getAttribute("filter") + "&filterValue=" + filterValue + "&docTitle=" + (String) getAttribute("docTitle");
        } else {
            return context + "/HelpServlet?op=Security";
        }
    }
    
    public String getDeleteLink(String filterBack,String filterName,String filterValue,String issueid) {
//        String filterValue = (String) viewOrigin.getAttribute("filterValue");
        // System.out.println("ARRR Filter Value" + filterValue);
        
        if(filterValue.indexOf("&")==0) {
            filterValue =  filterValue.replace('&','^');
            filterValue =  filterValue.replace('#','$');
        }
        
        if(this.isUserOwner || webUserGroup.equalsIgnoreCase("Administrator")) {
            return context + "/ImageReaderServlet?op=ConfirmDelete&docId=" + (String) getAttribute("docID") + "&filter=" + filterName +  "&filterBack=" + filterBack +"&filterValue=" + filterValue + "&issueid=" + issueid + "&docTitle=" + (String) getAttribute("docTitle");
        } else {
            return context + "/HelpServlet?op=Security";
        }
    }
    
    public String getDeleteRendering() {
        
        if(this.isUserOwner || webUserGroup.equalsIgnoreCase("Administrator")) {
            return tGuide.getMessage("delete");
        } else {
            return tGuide.getMessage("deny");
        }
    }
    
    public String getEditLink() {
        String filterValue = (String) viewOrigin.getAttribute("filterValue");
        // System.out.println("ARRR Filter Value" + filterValue);
        
        if(filterValue.indexOf("&")==0) {
            filterValue =  filterValue.replace('&','^');
            filterValue =  filterValue.replace('#','$');
        }
        
        if(this.isUserOwner || webUserGroup.equalsIgnoreCase("Administrator")) {
            return context + "/ImageWriterServlet?op=GetEditForm&docId=" + (String) getAttribute("docID") + "&filter=" + (String) viewOrigin.getAttribute("filter") + "&filterValue=" + filterValue + "&docTitle=" + (String) getAttribute("docTitle");
        } else {
            return context + "/HelpServlet?op=Security";
        }
    }
    
      public String getEditLink(String filterValue,String filterName) {
                
        if(filterValue.indexOf("&")==0) {
            filterValue =  filterValue.replace('&','^');
            filterValue =  filterValue.replace('#','$');
        }
        
        if(this.isUserOwner || webUserGroup.equalsIgnoreCase("Administrator")) {
            return context + "/ImageWriterServlet?op=GetEditForm&docId=" + (String) getAttribute("docID") + "&filter=" + (String) viewOrigin.getAttribute("filter") + "&filterValue=" + filterValue + "&docTitle=" + (String) getAttribute("docTitle")+ "&filterName=" + filterName;
        } else {
            return context + "/HelpServlet?op=Security";
        }
    }
    
    public String getEditRendering() {
        
        if(this.isUserOwner || webUserGroup.equalsIgnoreCase("Administrator")) {
            return tGuide.getMessage("edit");
        } else {
            return tGuide.getMessage("deny");
        }
    }
    
    public String getMoreDetailRendering() {
        
        return tGuide.getMessage("moredetails");
    }
    
    public String getBookmarkRendering() {
        
        return tGuide.getMessage("bookmark");
    }
    
    public String getUndoBookmarkRendering() {
        
        return tGuide.getMessage("unmark");
    }
    
    public String getViewDocumentLink() {
        
        String filterValue = (String) viewOrigin.getAttribute("filterValue");
        
        if(filterValue.indexOf("&")==0) {
            filterValue =  filterValue.replace('&','^');
            filterValue =  filterValue.replace('#','$');
        }
        
        return  context + "/ImageReaderServlet?op=ViewDocument&docType="+ getDocumentType()+"&docId=" + (String) getAttribute("docID") +
                "&metaType=" + (String) getAttribute("metaType") + "&filter=" + (String) viewOrigin.getAttribute("filter") + "&filterValue=" + filterValue;
        
        
    }
    
    
    public String getViewDocDetailsLink(String filterName,String filterValue,String issueid,String projectname) {
        
//        issueid =(String) viewOrigin.getAttribute("issueId");
//        System.out.println("issueid is " + issueid);
        
        // String filterValue = (String) viewOrigin.getAttribute("filterValue");
//        if (targetServlet==null){
//            targetServlet="ImageReaderServlet";
//        }
        
        if(filterValue.indexOf("&")==0) {
            filterValue =  filterValue.replace('&','^');
            filterValue =  filterValue.replace('#','$');
        }
        
        
        if(docType.equalsIgnoreCase("jpg")) {
            return  context + "/ImageReaderServlet?op=ViewDetailsImage&docId=" + (String) getAttribute("docID") +
                    "&metaType=" + (String) getAttribute("metaType") +  "&filter=" + filterName + "&filterValue=" + filterValue + "&issueId=" + issueid + "&projectName=" +projectname;
            
        } else {
            
            return  context + "/ImageReaderServlet?op=DocDetails&docId=" + (String) getAttribute("docID") +
                    "&metaType=" + (String) getAttribute("metaType") +  "&filter=" + filterName + "&filterValue=" + filterValue + "&issueId=" + issueid + "&projectName=" +projectname;
        }
        
    }
    
    public String getDisplyBookMarkFormLink() {
        
        String filterValue = (String) viewOrigin.getAttribute("filterValue");
        
        
        if(filterValue.indexOf("&")==0) {
            filterValue =  filterValue.replace('&','^');
            filterValue =  filterValue.replace('#','$');
        }
        
        return  context + "/ImageWriterServlet?op=GetBMForm&docId=" + (String) getAttribute("docID") +
                "&filter=" + (String) viewOrigin.getAttribute("filter") + "&filterValue=" + filterValue +  "&objType=" + (String) this.getAttribute("structureType")+  "&grandParent=" + (String) this.getAttribute("parentID");
        
    }
    
    public String getSearchDocumentLink() {
        
        if(docType.equalsIgnoreCase("sptr")) {
            
            return  context + "/ImageReaderServlet?op=ListSptr&docType="+ getDocumentType()+"&docId=" + (String) getAttribute("docID") +
                    "&metaType=" + (String) getAttribute("metaType") + "&filter=" + "ListSptr" + "&filterValue=" + (String) getAttribute("docID");
        }
        return null;
        
    }
    public String getBaselineLink() {
        String filterValue = (String) viewOrigin.getAttribute("filterValue");
        // System.out.println("ARRR Filter Value" + filterValue);
        
        if(filterValue.indexOf("&")==0) {
            filterValue =  filterValue.replace('&','^');
            filterValue =  filterValue.replace('#','$');
        }
        
        if(this.isUserOwner || webUserGroup.equalsIgnoreCase("Administrator")) {
            return context + "/ConfigurationServlet?op=MakeBaseline&docId=" + (String) getAttribute("docID") + "&filter=" + (String) viewOrigin.getAttribute("filter") + "&filterValue=" + filterValue + "&docTitle=" + (String) getAttribute("docTitle");
        } else {
            return context + "/HelpServlet?op=Security";
        }
    }
    
    public String getBaselineRendering() {
        
        if(this.isUserOwner || webUserGroup.equalsIgnoreCase("Administrator")) {
            return tGuide.getMessage("Mark");
        } else {
            return tGuide.getMessage("deny");
        }
    }
    
    public String getShowBaselineLink() {
        
        if(this.isUserOwner || webUserGroup.equalsIgnoreCase("Administrator")) {
            return context + "/ConfigurationServlet?op=ShowAllBaselines&docId=" + (String) getAttribute("docID")+ "&parentID=" + (String) getAttribute("parentID") +"&docTitle="+ (String) getAttribute("docTitle");
        } else {
            return context + "/HelpServlet?op=Security";
        }
    }
    
    public String getShowBaselineRendering() {
        
        String displayStatus = (String) getAttribute("displayStatus");
        if(this.isUserOwner || webUserGroup.equalsIgnoreCase("Administrator")) {
            if (displayStatus.equalsIgnoreCase("all")){
                return tGuide.getMessage("alreadyapplied");
            } else{
                return tGuide.getMessage("showbaseline");
            }
        } else {
            return tGuide.getMessage("deny");
        }
    }
    
    public String getShowLastBaselineLink() {
        
        if(this.isUserOwner || webUserGroup.equalsIgnoreCase("Administrator")) {
            return context + "/ConfigurationServlet?op=ShowLastBaseline&docId=" + (String) getAttribute("docID")+ "&parentID=" + (String) getAttribute("parentID") +"&docTitle="+ (String) getAttribute("docTitle");
        } else {
            return context + "/HelpServlet?op=Security";
        }
    }
    
    public String getShowLastBaselineRendering() {
        
        String displayStatus = (String) getAttribute("displayStatus");
        if(this.isUserOwner || webUserGroup.equalsIgnoreCase("Administrator")) {
            if (displayStatus.equalsIgnoreCase("last")){
                return tGuide.getMessage("alreadyapplied");
            } else{
                return tGuide.getMessage("showlastbaseline");
            }
        } else {
            return tGuide.getMessage("deny");
        }
    }
    
    public BigDecimal getMoney() {
        BigDecimal money = new BigDecimal((String) getAttribute("total"));
        
        return money;
        
    }
    
    public String getMoreDetailsLink() {
        return null;
    }
    
    public boolean isImage() {
        
        String metaType = (String) fileDescriptor.getAttribute("metaType");
        return metaType.equalsIgnoreCase("image")?true:false;
    }
    
    public boolean isPDF() {
        return docType.equalsIgnoreCase("pdfdoc")?true:false;
    }
    
    public String getDocumentType() {
        
        return docType;
    }
    
    
    public String getDisplayString() {
        
        
        if(docType.equalsIgnoreCase("audiodoc")) {
            return tGuide.getMessage("listendoc");
        } else
            return tGuide.getMessage("viewdoc");
    }
    
    public void setOwnerId(String id) {
        ownerId = id;
        
    }
    
    public void setSysUserId(String id) {
        sysUserId = id;
        
    }
    
    public void setViewrsIds(String ownerId,String sysUserId) {
        this.ownerId = ownerId;
        this.sysUserId = sysUserId;
        
        if(ownerId.equals(sysUserId)){
            isUserOwner = true;
        }
    }
    
    public boolean isUserOwner() {
        
        return isUserOwner;
    }
    
    public Vector getImages() {
        return docImages;
    }
    
    public void setImages(Vector v) {
        
        docImages = v;
        
    }
    
    public boolean isComplex() {
        
        int s = docImages.size();
        return (s==0?false:true);
        
    }
    
    public boolean equals(Object o) {
        
        System.out.println("Copmaring ...");
        //  this.printSelf();
        
        Document d = (Document) o;
        //   d.printSelf();
        String title = (String) d.getAttribute("docID");
        String thisTitle = (String) this.getAttribute("docID");
        
        if(thisTitle.equals(title))
            return true;
        else
            return false;
        
    }
    public Document getParent() {
        return parent;
        
    }
    
    public void setParent(Document p) {
        parent = p;
        
    }
    public String getColor() {
        String isLastBaseline = (String)getAttribute("isLastBaseline");
        if(isLastBaseline.equalsIgnoreCase("TRUE")) {
            return "#F1F27D";
        } else {
            return "#F0B7E2";
        }
    }
    public boolean isBaselined(){
        String isBaseline = (String) getAttribute("isBaseline");
        
        if(isBaseline.equalsIgnoreCase("TRUE")) {
            return true;
        } else {
            return false;
        }
    }
    
    public boolean isLastBaseline(){
        String isLastBaseline = (String) getAttribute("isLastBaseline");
        
        if(isLastBaseline.equalsIgnoreCase("TRUE")) {
            return true;
        } else {
            return false;
        }
    }
    public Document getViewDocumentLink(String sepID) {
        Document docObj = null;
        WebBusinessObject VO = null;
        
        try{
            Vector docObjs = (Vector)imgMgr.getOnArbitraryKey(sepID,"key1");
            if(null != docObjs) {
                Enumeration e = docObjs.elements();
                while(e.hasMoreElements()) {
                    docObj = (Document) e.nextElement();
                    if (docObj.getAttribute("isLastBaseline").equals("TRUE")){
                        String docId = (String)docObj.getAttribute("docID");
                        System.out.println("-------> "+ docId);
                        fileDescriptor = fileMgr.getObjectFromCash(docObj.getDocumentType());
                        DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
                        String configItemType = docTypeMgr.getDocTypeIcon((String)docObj.getAttribute("configItemType"));
                        break;
                    } else {
                        System.out.println("no last baseline ");
                    }
                }
                return docObj;
            }
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
        return  null;
        
        
    }
}



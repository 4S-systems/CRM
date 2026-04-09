/*
 * FavoritesBuilder.java
 *
 * Created on 2005-06-21, 5.40.MD
 *
 * To change this template, choose Tools | Options and locate the template under
 * the Source Creation and Management node. Right-click the template and choose
 * Open. You can then make changes to the template in the Source Editor.
 */
package com.docviewer.db_access;

import com.silkworm.db_access.IBuildFavorites;
import com.silkworm.common.BookmarkMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.docviewer.business_objects.*;
import java.sql.SQLException;

import java.util.*;

/**
 *
 * @author Administrator
 */
public class FavoritesBuilder implements IBuildFavorites {

    /** Creates a new instance of FavoritesBuilder */
    private Vector userFavorits = null;
    private ImageMgr imgMgr = ImageMgr.getInstance();
    private BookmarkMgr bmMgr = BookmarkMgr.getInstance();
    private WebBusinessObject currentUser = null;

    public FavoritesBuilder(WebBusinessObject systemUser) {
        currentUser = systemUser;
    }

    public void setCurrentUser(WebBusinessObject systemUser) {
        currentUser = systemUser;

    }

    public Vector buildUserFavorits() {

        userFavorits = new Vector();
        String userId = (String) currentUser.getAttribute("userId");
        WebBusinessObject wbo = null;
        Document favoredDoc = null;

        WebBusinessObject viewOrigin = new WebBusinessObject();
        viewOrigin.setAttribute("filter", "MyFavorits");
        viewOrigin.setAttribute("filterValue", "");

        try {

            Vector usrBMS = bmMgr.getOnArbitraryKey(userId, "key1");

            if (null == usrBMS) {
                return null;
            }

            Enumeration e = usrBMS.elements();

            // WebBusinessObject for parentssent

            while (e.hasMoreElements()) {

                wbo = (WebBusinessObject) e.nextElement();

                String objType = (String) wbo.getAttribute("objectType");

                if (objType.equalsIgnoreCase("DCMNT_TYPE")) {

                    favoredDoc = (Document) imgMgr.getOnSingleKey((String) wbo.getAttribute("parentId"));
                    favoredDoc.setViewOrigin(viewOrigin);
                    userFavorits.addElement(favoredDoc);
                }
            }

        } catch (SQLException e) {
            return null;
        } catch (Exception ex) {
            return null;
        }
        return userFavorits;

    }

    public Vector buildLinkedFavoritsTree() {

        Vector favDocs = this.buildUserFavorits();

        Vector separators = new Vector();
        Vector folders = new Vector();

        Vector cabinets = new Vector();

        Enumeration e = favDocs.elements();
        Document favDoc = null;
        Document parent = null;
        Document cbnt = null;

        Document sep = null;
        Document fldr = null;

        String parentID = null;

        Cabinet c = null;
        Folder f = null;
        Separator s = null;
        while (e.hasMoreElements()) {
            favDoc = (Document) e.nextElement();
            parent = (Document) imgMgr.getOnSingleKey((String) favDoc.getAttribute("parentID"));
            sep = parent;

            s = new Separator(sep);

            if (!separators.contains(s)) {
                separators.addElement(s);
            }

            parent = (Document) imgMgr.getOnSingleKey((String) sep.getAttribute("parentID"));
            fldr = parent;

            f = new Folder(fldr);

            if (!folders.contains(f)) {
                folders.addElement(f);
            }

            parent = (Document) imgMgr.getOnSingleKey((String) fldr.getAttribute("parentID"));
            cbnt = parent;

            c = new Cabinet(cbnt);

            if (!cabinets.contains(c)) {
                cabinets.addElement(c);
            }

        }

        Enumeration se = separators.elements();

        Separator smold = null;
        Vector sepChildren = null;
        while (se.hasMoreElements()) {
            smold = (Separator) se.nextElement();

            String sepID = (String) smold.getAttribute("docID");
            sepChildren = getMyChildren(sepID, favDocs);
            smold.setChildDocs(sepChildren);
        }
        Enumeration fe = folders.elements();

        Folder fmold = null;
        Vector fldrChildren = null;
        while (fe.hasMoreElements()) {
            fmold = (Folder) fe.nextElement();
            String fldrID = (String) fmold.getAttribute("docID");
            fldrChildren = getMyChildren(fldrID, separators);
            fmold.setChildContainers(fldrChildren);

        }

        Enumeration ce = cabinets.elements();

        Cabinet cmold = null;
        Vector cbntChildren = null;
        while (ce.hasMoreElements()) {
            cmold = (Cabinet) ce.nextElement();
            String cbntID = (String) cmold.getAttribute("docID");
            cbntChildren = getMyChildren(cbntID, folders);
            cmold.setChildContainers(cbntChildren);

        }
        return cabinets;
    }

    private Vector getMyChildren(String myID, Vector v) {
        WebBusinessObject wbo = null;
        String parentID = null;
        Vector retVal = new Vector();

        Enumeration e = v.elements();

        while (e.hasMoreElements()) {
            wbo = (WebBusinessObject) e.nextElement();
            parentID = (String) wbo.getAttribute("parentID");
            if (parentID.equals(myID)) {
                retVal.addElement(wbo);
            }
        }

        return retVal;
    }

    public Vector buildUserFavoritsNodes() {

        Vector nodes = null;
        Vector favDocs = this.buildUserFavorits();

        if (null != favDocs) {

            nodes = new Vector();

            Enumeration e = favDocs.elements();

            Document favDoc = null;
            Document parent = null;

            Document sep = null;
            Document fldr = null;

            String parentID = null;

            while (e.hasMoreElements()) {
                favDoc = (Document) e.nextElement();

                parent = (Document) imgMgr.getOnSingleKey((String) favDoc.getAttribute("parentID"));
                sep = parent;

                parent = (Document) imgMgr.getOnSingleKey((String) sep.getAttribute("parentID"));
                fldr = parent;

                sep.setParent(fldr);
                favDoc.setParent(sep);

                nodes.addElement(favDoc);

            }

        }

        return nodes;
    }
}

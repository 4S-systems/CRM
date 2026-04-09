/*
 * DocViewerWebApplication.java
 *
 * Created on March 18, 2004, 10:59 PM
 */

package com.docviewer.common;



import com.silkworm.common.swWebApplication;

import com.silkworm.persistence.relational.*;
import java.sql.*;
import javax.sql.*;
import java.util.Properties;
import com.silkworm.common.UserMgr;
import com.silkworm.common.*;
import com.silkworm.common.bus_admin.AccountMgr;
import com.silkworm.common.bus_admin.ClassMgr;
import com.silkworm.db_access.FileMgr;
import com.docviewer.db_access.DocImgMgr;
import com.tracker.db_access.*;
import com.docviewer.db_access.*;
import com.silkworm.db_access.FavoritesMgr;


public class DocViewerWebApplication extends swWebApplication {
    
    
    
    public DocViewerWebApplication() {
    }
    
    public DocViewerWebApplication(String driverClass,String databaseURL,Properties connectionAttributes,String[] sys_paths) throws SQLException,Exception {
        super(driverClass,databaseURL,connectionAttributes,sys_paths);
    }
    
    public void init() throws Exception {
        // initialize application managers with the data source aand other important variables
        
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        metaMgr.setWebInfPath(webInfPath);
        metaMgr.setMetaData("xfile.jar");
        
        UserMgr  userMgr = UserMgr.getInstance();
        userMgr.setWebInfPath(webInfPath);
        userMgr.setDataSource(dataSource);
        userMgr.setSysPaths(sys_paths);
        userMgr.cashData();
        
        GroupMgr groupMgr = GroupMgr.getInstance();
        groupMgr.setWebInfPath(webInfPath);
        groupMgr.setDataSource(dataSource);
        groupMgr.cashData();
        
        FileMgr fileMgr = FileMgr.getInstance();
        fileMgr.setWebInfPath(webInfPath);
        fileMgr.setDataSource(dataSource);
        fileMgr.cashData();
        //fileMgr.printCashedTable();
        
        DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
        docTypeMgr.setWebInfPath(webInfPath);
        docTypeMgr.setDataSource(dataSource);
        docTypeMgr.cashData();
        
        
        UserGroupMgr userGroupMgr = UserGroupMgr.getInstance();
        userGroupMgr.setWebInfPath(webInfPath);
        userGroupMgr.setDataSource(dataSource);
        
        BookmarkMgr bmMgr = BookmarkMgr.getInstance();
        bmMgr.setWebInfPath(webInfPath);
        bmMgr.setDataSource(dataSource);
        
        AccountMgr  accntMgr = AccountMgr.getInstance();
        accntMgr.setWebInfPath(webInfPath);
        accntMgr.setDataSource(dataSource);
        accntMgr.cashData();
        
        ClassMgr  classMgr = ClassMgr.getInstance();
        classMgr.setWebInfPath(webInfPath);
        classMgr.setDataSource(dataSource);
        classMgr.cashData();
        
        AccountItemMgr accntItemMgr = AccountItemMgr.getInstance();
        accntItemMgr.setWebInfPath(webInfPath);
        accntItemMgr.setDataSource(dataSource);
        accntItemMgr.cashData();
        
        
        // -----------------------------------------
        
        ImageMgr imageMgr = ImageMgr.getInstance();
        imageMgr.setWebInfPath(webInfPath);
        imageMgr.setDataSource(dataSource);
        
        DocImgMgr diMgr = DocImgMgr.getInstance();
        diMgr.setWebInfPath(webInfPath);
        diMgr.setDataSource(dataSource);
        
        
        CabinetMgr cbntMgr = CabinetMgr.getInstance();
        cbntMgr.setWebInfPath(webInfPath);
        cbntMgr.setDataSource(dataSource);
        cbntMgr.cashData();
        
        FolderMgr fldrMgr = FolderMgr.getInstance();
        fldrMgr.setWebInfPath(webInfPath);
        fldrMgr.setDataSource(dataSource);
        //fldrMgr.buildSysFoldersData();
        
        SeparatorMgr sprtrMgr = SeparatorMgr.getInstance();
        sprtrMgr.setWebInfPath(webInfPath);
        sprtrMgr.setDataSource(dataSource);
        //sprtrMgr.cashData();
        
        
        FavoritesMgr fvtsMgr = FavoritesMgr.getInstance();
        fvtsMgr.setWebInfPath(webInfPath);
        fvtsMgr.setDataSource(dataSource);
        
        InfluenceMgr influenceMgr = InfluenceMgr.getInstance();
        influenceMgr.setWebInfPath(webInfPath);
        influenceMgr.setDataSource(dataSource);
        influenceMgr.cashData();
        
        AssignedIssueMgr assignedIssueMgr = AssignedIssueMgr.getInstance();
        assignedIssueMgr.setWebInfPath(webInfPath);
        assignedIssueMgr.setDataSource(dataSource);
        assignedIssueMgr.cashData();
        
        MaintenanceMgr maintenanceMgr = MaintenanceMgr.getInstance();
        maintenanceMgr.setWebInfPath(webInfPath);
        maintenanceMgr.setDataSource(dataSource);
        maintenanceMgr.cashData();
        
        IssueMgr issueMgr = IssueMgr.getInstance();
        issueMgr.setWebInfPath(webInfPath);
        issueMgr.setDataSource(dataSource);
        issueMgr.cashData();
        
        IssueTypeMgr issueTypeMgr = IssueTypeMgr.getInstance();
        issueTypeMgr.setWebInfPath(webInfPath);
        issueTypeMgr.setDataSource(dataSource);
        issueTypeMgr.cashData();
        
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        projectMgr.setWebInfPath(webInfPath);
        projectMgr.setDataSource(dataSource);
        projectMgr.cashData();
        
        UrgencyMgr urgencyMgr = UrgencyMgr.getInstance();
        urgencyMgr.setWebInfPath(webInfPath);
        urgencyMgr.setDataSource(dataSource);
        urgencyMgr.cashData();
        
        DocTypeMgr doctypeMgr = DocTypeMgr.getInstance();
        doctypeMgr.setWebInfPath(webInfPath);
        doctypeMgr.setDataSource(dataSource);
        doctypeMgr.cashData();
        
        LockMgr lockMgr = LockMgr.getInstance();
        lockMgr.setWebInfPath(webInfPath);
        lockMgr.setDataSource(dataSource);
        lockMgr.cashData();
        
        ChangeRequestMgr changeRequestMgr = ChangeRequestMgr.getInstance();
        changeRequestMgr.setWebInfPath(webInfPath);
        changeRequestMgr.setDataSource(dataSource);
        //urgencyMgr.cashData();
        
        FolderGroupMgr folderGroupMgr = FolderGroupMgr.getInstance();
        folderGroupMgr.setWebInfPath(webInfPath);
        folderGroupMgr.setDataSource(dataSource);
        
    }
    
}

package com.callcenter.util;

import com.silkworm.common.MetaDataMgr;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import jcifs.smb.NtlmPasswordAuthentication;
import jcifs.smb.SmbException;
import jcifs.smb.SmbFile;
import jcifs.smb.SmbFileInputStream;

public class SambaReadingUtil {

    private final String server;
    private final String userName;
    private final String password;
    private final MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();

    public SambaReadingUtil() {
        server = metaDataMgr.getSambaServer();
        userName = metaDataMgr.getSambaUserName();
        password = metaDataMgr.getSambaPassword();
    }

    public ArrayList<String> getOutFileList() {
        ArrayList<String> fileList = new ArrayList<>();
        try {
            SmbFile serverSambaDir = new SmbFile("smb://" + server + "/call_recordings/");
            SmbFile[] shares = serverSambaDir.listFiles();
            for (SmbFile file : shares) {
                if (file.getName().contains("out")) {
                    fileList.add(file.getName());
                }
            }
        } catch (MalformedURLException | SmbException ex) {
            Logger.getLogger(SambaReadingUtil.class.getName()).log(Level.SEVERE, null, ex);
        }
        return fileList;
    }

    public InputStream getFile(String fileName) {
        try {
            NtlmPasswordAuthentication auth = new NtlmPasswordAuthentication("", userName, password);
            SmbFile fileSamba = new SmbFile("smb://" + server + "/call_recordings/" + fileName, auth);
            return fileSamba.getInputStream();
//            SmbFile[] shares = fileSamba.listFiles();
//            for (SmbFile file : shares) {
//                if (file.getName().equals(fileName)) {
//                    System.out.println("can read -->> " + file.canRead() + " exist -->> " + file.exists());
//                    SmbFileInputStream fileInputStream = new SmbFileInputStream(file);
//                    return fileInputStream;
////                    return file.getInputStream();
//                }
//            }
        } catch (MalformedURLException ex) {
            Logger.getLogger(SambaReadingUtil.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(SambaReadingUtil.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
}

package com.silkworm.uploader;

import java.io.InputStream;

public class FileMeta {

    private String fileName;
    private int fileSize;
    private String fileType;

    private InputStream content;

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public int getFileSize() {
        return fileSize;
    }

    public void setFileSize(int fileSize) {
        this.fileSize = fileSize;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public InputStream getContent() {
        return this.content;
    }

    public void setContent(InputStream content) {
        this.content = content;
    }

    @Override
    public String toString() {
        return "FileMeta [fileName=" + fileName + ", fileSize=" + fileSize + ", fileType=" + fileType + "]";
    }
}

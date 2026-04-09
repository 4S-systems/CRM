/*
 * ImageValue.java
 *
 * Created on March 26, 2004, 7:29 AM
 */
package com.silkworm.persistence.relational;

import java.io.*;

/**
 *
 * @author walid
 */
public class ImageValue extends Value {

    /**
     * Creates a new instance of ImageValue
     */
    private File imageFile = null;
    private int length;
    private InputStream stream = null;

    public ImageValue(File imageFile) {
        this.imageFile = imageFile;
        try {
            this.length = (int) imageFile.length();
            this.stream = new FileInputStream(imageFile);
        } catch (FileNotFoundException fnfex) {
            System.out.println("Severe Error: Unable to locate image file for insertion " + fnfex);
        }
    }

    public ImageValue(InputStream stream, int length) {
        this.stream = stream;
        this.length = length;
    }

    @Override
    public InputStream getImageStream() {
        return stream;
    }

    @Override
    public int getImageFileLength() {
        return length;
    }

    @Override
    public String getString() {
        return "This is an image!!";
    }
}

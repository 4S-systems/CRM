package com.silkworm.util;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EncryptUtil {

    private final static String salt = "DGE$5SGr@3VsHYUMas2323E4d57vfBfFSTRU@!DSH(*%FDSdfg13sgfsg";

    public EncryptUtil() {
    }

    public static String encryptString(String value) {
        try {
            System.out.println("en == >> " + getSHAEncrypt(value, 512));
        } catch (Exception ex) {
            Logger.getLogger(EncryptUtil.class.getName()).log(Level.SEVERE, null, ex);
        }
        return md5Hash(value);
    }

    private static String md5Hash(String message) {
        String md5 = "";
        if (null == message) {
            return null;
        }
        message = message + salt;//adding a salt to the string before it gets hashed.
        try {
            MessageDigest digest = MessageDigest.getInstance("MD5");//Create MessageDigest object for MD5
            digest.update(message.getBytes(), 0, message.length());//Update input string in message digest
            md5 = new BigInteger(1, digest.digest()).toString(16);//Converts message digest value in base 16 (hex)

        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return md5;
    }
    
    private static String getSHAEncrypt(String value, int bits) throws Exception { // bits --> 1 224 256 384 or 512
        MessageDigest didest = MessageDigest.getInstance("SHA-" + bits);
        didest.update(value.getBytes(), 0, value.length());
        return new BigInteger(1, didest.digest()).toString(16).toUpperCase();
    }
}

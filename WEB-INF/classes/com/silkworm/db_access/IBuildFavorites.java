/*
 * IBuildFavorites.java
 *
 * Created on 2005-06-21, 5.31.MD
 *
 * To change this template, choose Tools | Options and locate the template under
 * the Source Creation and Management node. Right-click the template and choose
 * Open. You can then make changes to the template in the Source Editor.
 */

package com.silkworm.db_access;

import java.util.*;

/**
 *
 * @author Administrator
 */
public interface IBuildFavorites {
    public Vector buildUserFavorits();
    public Vector buildLinkedFavoritsTree();
    public Vector buildUserFavoritsNodes();
    
}

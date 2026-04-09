/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.silkworm.email;

/**
 *
 * @author WALEED
 */
public class ParameterNotFoundException extends Exception {

  /**
   * Constructs a new ParameterNotFoundException with no detail message.
   */
  public ParameterNotFoundException() {
    super();
  }

  /**
   * Constructs a new ParameterNotFoundException with the specified
   * detail message.
   *
   * @param s the detail message
   */
  public ParameterNotFoundException(String s) {
    super(s);
  }
}

/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 * <p>
 * http://www.apache.org/licenses/LICENSE-2.0
 * <p>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.datayoo.botu.operand.function.string;

import org.datayoo.moql.EntityMap;
import org.datayoo.moql.Operand;
import org.datayoo.moql.operand.function.AbstractFunction;

import java.util.List;

/**
 * @author Tang Tadin
 */
public class Trim extends AbstractFunction {

  public static final String FUNCTION_NAME = "trim";

  protected Operand field;

  protected Operand pattern;

  public Trim(List<Operand> parameters) {
    super(FUNCTION_NAME, 2, parameters);
    field = parameters.get(0);
    pattern = parameters.get(1);
  }

  @Override
  protected Object innerOperate(EntityMap entityMap) {
    // TODO Auto-generated method stub
    Object obj = field.operate(entityMap);
    if (obj == null)
      return null;
    String src = obj.toString();
    int begin = 0, end = 0, index = 0;
    String patt = (String) pattern.operate(entityMap);
    int len = patt.length();
    int offset = 0;
    //search the destination string at source string's head
    while (true) {
      index = src.indexOf(patt, offset);
      if (index != offset)
        break;
      offset += len;
    }
    begin = offset;
    //		search the destination string at source string's tail
    offset = src.length() - 1;
    while (true) {
      index = src.lastIndexOf(patt, offset);
      if (index != offset)
        break;
      offset -= len;
    }
    end = offset + 1;
    if (begin >= end)
      return "";
    return src.substring(begin, end);
  }

  @Override
  protected Object innerOperate(Object[] entityArray) {
    // TODO Auto-generated method stub
    Object obj = field.operate(entityArray);
    if (obj == null)
      return null;
    String src = obj.toString();
    int begin = 0, end = 0, index = 0;
    String patt = (String) pattern.operate(entityArray);
    int len = patt.length();
    int offset = 0;
    //search the destination string at source string's head
    while (true) {
      index = src.indexOf(patt, offset);
      if (index != offset)
        break;
      offset += len;
    }
    begin = offset;
    //		search the destination string at source string's tail
    offset = src.length() - 1;
    while (true) {
      index = src.lastIndexOf(patt, offset);
      if (index != offset)
        break;
      offset -= len;
    }
    end = offset + 1;
    if (begin >= end)
      return "";
    return src.substring(begin, end);
  }

}

/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.hadoop.hive.ql.exec.vector.expressions;

import org.apache.hadoop.hive.ql.exec.vector.BytesColumnVector;
import org.apache.hadoop.hive.ql.exec.vector.DecimalColumnVector;

/**
 * To support vectorized cast of decimal to string.
 */
public class CastDecimalToString extends DecimalToStringUnaryUDF {

  private static final long serialVersionUID = 1L;

  public CastDecimalToString() {
    super();
  }

  public CastDecimalToString(int inputColumn, int outputColumn) {
    super(inputColumn, outputColumn);
  }

  // The assign method will be overridden for CHAR and VARCHAR.
  protected void assign(BytesColumnVector outV, int i, byte[] bytes, int length) {
    outV.setVal(i, bytes, 0, length);
  }

  @Override
  protected void func(BytesColumnVector outV, DecimalColumnVector inV, int i) {
    String s = inV.vector[i].getHiveDecimal().toString();
    byte[] b = null;
    try {
      b = s.getBytes("UTF-8");
    } catch (Exception e) {
      // This should never happen. If it does, there is a bug.
      throw new RuntimeException("Internal error:  unable to convert decimal to string", e);
    }
    assign(outV, i, b, b.length);
  }
}

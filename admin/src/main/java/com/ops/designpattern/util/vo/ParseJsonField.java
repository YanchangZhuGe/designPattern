package com.ops.designpattern.util.vo;

import java.lang.annotation.*;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/7/22 10:39
 */

@Documented
@Inherited
@Target({ElementType.FIELD, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)

public @interface ParseJsonField {
 public String type() default "";

 public String value() default "";
}

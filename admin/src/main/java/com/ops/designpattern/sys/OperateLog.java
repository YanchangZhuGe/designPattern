package com.ops.designpattern.sys;

import java.lang.annotation.*;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/7/20 16:47
 */

@Inherited
@Documented
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface OperateLog {
}

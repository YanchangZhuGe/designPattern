package com.bgd.api.common.constants;

/**
 * 长度校验使用的数字
 * 严禁其他的用途直接使用此类的数字（避免后续改动引起问题）
 * 如果要修改常量的值，务必要确定每一个地方都需要改动，否则不应直接修改常量的值
 * （使用此类的目的是所有接口的长度均使用此类，
 * 这样后续一旦出现数据库位数不一致的时候，可以直接修改此类，而不用每一个地方去改）
 * <p>
 * 原设计是如上面所述，但是发现编译时，无法在注解中识别此类的引用，编辑报错，所以舍弃此设计
 * 这里保留此类，仅作之前做过此设计的参考
 */
@Deprecated
public class NumberCheckConstants {

    public static final Integer SIZE_2 = 2;

    public static final Integer SIZE_4 = 4;

    public static final Integer SIZE_8 = 8;

    public static final Integer SIZE_16 = 16;

    public static final Integer SIZE_32 = 32;

    public static final Integer SIZE_64 = 64;

    public static final Integer SIZE_128 = 128;

    public static final Integer SIZE_256 = 256;

    public static final Integer SIZE_512 = 512;

    public static final Integer SIZE_1024 = 1024;
}

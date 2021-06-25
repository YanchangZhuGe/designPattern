package designPattern.behavior.nullObject;

/**
 * 描述:创建一个抽象类。
 *
 * @author WuYanchang
 * @date 2021/6/25 15:16
 */

public abstract class AbstractCustomer {
    protected String name;

    public abstract boolean isNil();

    public abstract String getName();
}

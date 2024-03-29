package designPattern.behavior.nullObject;

/**
 * 描述:创建扩展了上述类的实体类。
 *
 * @author WuYanchang
 * @date 2021/6/25 15:17
 */

public class NullCustomer extends AbstractCustomer {

    @Override
    public String getName() {
        return "Not Available in Customer Database";
    }

    @Override
    public boolean isNil() {
        return true;
    }

}

package designPattern.behavior.nullObject;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/25 15:17
 */

public class RealCustomer  extends AbstractCustomer {

    public RealCustomer(String name) {
        this.name = name;
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public boolean isNil() {
        return false;
    }

}

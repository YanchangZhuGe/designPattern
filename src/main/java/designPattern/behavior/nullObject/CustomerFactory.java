package designPattern.behavior.nullObject;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/25 15:18
 */

public class CustomerFactory {

    public static final String[] names = {"Rob", "Joe", "Julie"};

    public static AbstractCustomer getCustomer(String name){
        for (int i = 0; i < names.length; i++) {
            if (names[i].equalsIgnoreCase(name)){
                return new RealCustomer(name);
            }
        }
        return new NullCustomer();
    }
}

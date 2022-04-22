package designPattern.creativion.builder;

/**
 * 描述: 汉堡包
 *
 * @author WuYanchang
 * @date 2021/5/20 14:34
 */

public abstract class Burger implements Item {


    @Override
    public Packing packing() {
        return new Wrapper();
    }

    @Override
    public abstract float price();
}

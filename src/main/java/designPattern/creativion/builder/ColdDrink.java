package designPattern.creativion.builder;

/**
 * 描述: 饮品
 *
 * @author WuYanchang
 * @date 2021/5/20 14:37
 */

public abstract class ColdDrink implements Item {

    @Override
    public Packing packing() {
        return new Bottle();
    }

    @Override
    public abstract float price();
}

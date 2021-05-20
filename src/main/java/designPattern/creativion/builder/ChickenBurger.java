package designPattern.creativion.builder;

/**
 * 描述: 扩展汉堡类
 *
 * @author WuYanchang
 * @date 2021/5/20 14:49
 */

public class ChickenBurger extends Burger {

    @Override
    public String name() {
        return "Chicken Burger 鸡肉汉堡";
    }

    @Override
    public float price() {
        return 50.5f;
    }
}

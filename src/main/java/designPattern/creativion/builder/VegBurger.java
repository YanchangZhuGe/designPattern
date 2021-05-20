package designPattern.creativion.builder;

/**
 * 描述: 扩展汉堡类
 *
 * @author WuYanchang
 * @date 2021/5/20 14:45
 */

public class VegBurger extends Burger {

    @Override
    public String name() {
        return "Veg Burger 蔬菜汉堡";
    }

    @Override
    public float price() {
        return 25.0f;
    }
}

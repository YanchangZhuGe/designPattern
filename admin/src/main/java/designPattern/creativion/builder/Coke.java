package designPattern.creativion.builder;

/**
 * 描述: 扩展饮品
 *
 * @author WuYanchang
 * @date 2021/5/20 14:51
 */

public class Coke extends ColdDrink {

    @Override
    public String name() {
        return "Coke 可口可乐";
    }

    @Override
    public float price() {
        return 30.0f;
    }
}

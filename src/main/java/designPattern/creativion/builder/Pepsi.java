package designPattern.creativion.builder;

/**
 * 描述: 扩展饮品
 *
 * @author WuYanchang
 * @date 2021/5/20 14:56
 */

public class Pepsi extends ColdDrink{

    @Override
    public String name() {
        return "Pepsi 百事可乐";
    }

    @Override
    public float price() {
        return 35.0f;
    }
}

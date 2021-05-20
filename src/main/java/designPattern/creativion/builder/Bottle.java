package designPattern.creativion.builder;

/**
 * 描述: 饮品包装
 *
 * @author WuYanchang
 * @date 2021/5/20 14:31
 */

public class Bottle implements Packing {

    @Override
    public String pack() {
        return "Bottle-玻璃瓶包装";
    }
}

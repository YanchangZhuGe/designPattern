package designPattern.creativion.builder;

/**
 * 描述: 食物包装
 *
 * @author WuYanchang
 * @date 2021/5/20 14:29
 */

public class Wrapper implements Packing {

    @Override
    public String pack() {
        return "Wrapper-纸盒包装";
    }
}

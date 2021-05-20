package designPattern.creativion.builder;

/**
 * 描述: 食物条目
 *
 * @author WuYanchang
 * @date 2021/5/20 14:26
 */

public interface Item {
    String name();

    Packing packing();

    float price();
}

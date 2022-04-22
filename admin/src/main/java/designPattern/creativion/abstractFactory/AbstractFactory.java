package designPattern.creativion.abstractFactory;

import designPattern.creativion.factory.Shape;

/**
 * 描述: 抽象接口-生产颜色,形状
 *
 * @author WuYanchang
 * @date 2021/5/17 9:54
 */
public interface AbstractFactory {

    public abstract Color getColor(String color);

    public abstract Shape getShape(String shape);
}

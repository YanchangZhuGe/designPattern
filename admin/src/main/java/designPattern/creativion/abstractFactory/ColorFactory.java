package designPattern.creativion.abstractFactory;

import designPattern.creativion.factory.Shape;

/**
 * 描述: 生产颜色类
 *
 * @author WuYanchang
 * @date 2021/5/17 9:57
 */

public class ColorFactory implements AbstractFactory {

    @Override
    public Color getColor(String color) {
        if (color == null) {
            return null;
        }
        if (color.equalsIgnoreCase("RED")) {
            return new Red();
        } else if (color.equalsIgnoreCase("GREEN")) {
            return new Green();
        } else if (color.equalsIgnoreCase("BLUE")) {
            return new Blue();
        }
        return null;
    }

    @Override
    public Shape getShape(String shape) {
        return null;
    }
}

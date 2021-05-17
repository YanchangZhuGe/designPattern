package designPattern.creativion.abstractFactory;

import designPattern.creativion.factory.*;
import org.springframework.util.StringUtils;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/5/17 9:56
 */

public class ShapeFactory implements AbstractFactory{

    @Override
    public Color getColor(String color) {
        return null;
    }

    @Override
    public Shape getShape(String shapeType) {

        //参数为空, 返回null
        if (StringUtils.hasText(shapeType)) {
            if (shapeType.equalsIgnoreCase("CIRCLE")) {
                return new Circle();
            } else if (shapeType.equalsIgnoreCase("RECTANGLE")) {
                return new Rectangle();
            } else if (shapeType.equalsIgnoreCase("SQUARE")) {
                return new Square();
            } else {
                return new TestNull();
            }
        }

        return null;
    }
}

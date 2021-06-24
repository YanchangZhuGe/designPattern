package designPattern.structural.flyweight;

import java.util.HashMap;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/24 20:47
 */

public class ShapeFactory {
    private static final HashMap<String, Shape> circleMap = new HashMap<>();

    public static Shape getCircle(String color) {
        Circle circle = (Circle)circleMap.get(color);

        if(circle == null) {
            circle = new Circle(color);
            circleMap.put(color, circle);
            System.out.println("Creating circle of color : " + color);
        }
        return circle;
    }
}

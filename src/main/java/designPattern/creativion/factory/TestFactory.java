package designPattern.creativion.factory;

/**
 * 描述: 测试
 *
 * @author WuYanchang
 * @date 2021/5/14 16:52
 */

public class TestFactory {
    public static void main(String[] args) {
        //实例化-工厂类
        ShapeFactory shapeFactory = new ShapeFactory();

        //获取 Circle 的对象，并调用它的 draw 方法
        Shape circle = shapeFactory.getShape("circle");
        circle.draw();

        //获取 Rectangle 的对象，并调用它的 draw 方法
        Shape rectangle = shapeFactory.getShape("RECTANGLE");
        rectangle.draw();

        //获取 Square 的对象，并调用它的 draw 方法
        Shape square = shapeFactory.getShape("Square");
        square.draw();

        /**
         * StringUtils.hasText("    ") 返回 false
         * StringUtils.hasLength("    ") 返回 true
         * StringUtils.isEmpty("    ") 返回 false
         */
        Shape shape = shapeFactory.getShape("    ");
        shape.draw();
    }
}

package designPattern.creativion.factory;


import org.springframework.util.StringUtils;

/**
 * 描述: 生产产品的实体类
 *
 * @author WuYanchang
 * @date 2021/5/14 16:23
 */

public class ShapeFactory {

    //使用 getShape 方法获取形状类型的对象
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

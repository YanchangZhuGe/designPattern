package designPattern.creativion.factory.bingHe;

import designPattern.creativion.factory.Circle;
import designPattern.creativion.factory.Shape;

/**
 * 描述: 引用原-圆类型
 *
 * @author WuYanchang
 * @date 2021/5/14 17:45
 */

public class CircleCreate implements ShapeCreate {

    @Override
    public Shape getShape() {
        return new Circle();
    }
}

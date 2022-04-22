package designPattern.creativion.factory.bingHe;

import designPattern.creativion.factory.Shape;

/**
 * 描述: 生产-线条的工厂
 *
 * @author WuYanchang
 * @date 2021/5/14 17:52
 */

public class LineCreate implements ShapeCreate{

    @Override
    public Shape getShape() {
        return new Line();
    }
}

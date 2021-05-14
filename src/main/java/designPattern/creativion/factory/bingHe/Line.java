package designPattern.creativion.factory.bingHe;

import designPattern.creativion.factory.Shape;

/**
 * 描述: 形状-线条
 *
 * @author WuYanchang
 * @date 2021/5/14 17:51
 */

public class Line implements Shape {

    @Override
    public void draw() {
        System.out.println("二次抽象-line");
    }
}

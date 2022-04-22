package designPattern.structural.facade;

/**
 * 描述:使用该外观类画出各种类型的形状。
 *
 * @author WuYanchang
 * @date 2021/6/24 20:44
 */

public class Test {
    public static void main(String[] args) {
        ShapeMaker shapeMaker = new ShapeMaker();

        shapeMaker.drawCircle();
        shapeMaker.drawRectangle();
        shapeMaker.drawSquare();
    }
}

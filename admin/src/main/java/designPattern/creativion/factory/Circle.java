package designPattern.creativion.factory;

/**
 * 描述: 产品-圆形
 *
 * @author WuYanchang
 * @date 2021/5/14 16:22
 */

public class Circle implements Shape {

    @Override
    public void draw() {
        System.out.println("Inside Circle::draw() method.");
    }
}

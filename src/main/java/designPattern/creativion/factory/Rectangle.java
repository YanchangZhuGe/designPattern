package designPattern.creativion.factory;

/**
 * 描述: 产品-矩形
 *
 * @author WuYanchang
 * @date 2021/5/14 16:20
 */

public class Rectangle implements Shape {

    @Override
    public void draw() {
        System.out.println("Inside Rectangle::draw() method.");
    }
}

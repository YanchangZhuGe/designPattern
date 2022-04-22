package designPattern.structural.facade;

/**
 * 描述:创建一个外观类。
 *
 * @author WuYanchang
 * @date 2021/6/24 20:42
 */

public class Rectangle implements Shape {

    @Override
    public void draw() {
        System.out.println("Rectangle::draw()");
    }

}

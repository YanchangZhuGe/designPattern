package designPattern.structural.decorator;

/**
 * 描述:创建实现接口的实体类
 *
 * @author WuYanchang
 * @date 2021/6/24 20:38
 */

public class Rectangle implements Shape {

    @Override
    public void draw() {
        System.out.println("Shape: Rectangle");
    }

}

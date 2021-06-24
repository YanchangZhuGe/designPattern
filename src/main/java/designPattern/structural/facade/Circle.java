package designPattern.structural.facade;

/**
 * 描述:创建实现接口的实体类。
 *
 * @author WuYanchang
 * @date 2021/6/24 20:43
 */

public class Circle implements Shape {

    @Override
    public void draw() {
        System.out.println("Circle::draw()");
    }

}

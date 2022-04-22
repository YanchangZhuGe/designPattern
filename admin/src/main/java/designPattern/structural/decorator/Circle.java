package designPattern.structural.decorator;

/**
 * 创建实现接口的实体类
 *
 * @author WuYanchang
 * @date 2021/6/24 20:38
 */

public class Circle implements Shape {

    @Override
    public void draw() {
        System.out.println("Shape: Circle");
    }

}

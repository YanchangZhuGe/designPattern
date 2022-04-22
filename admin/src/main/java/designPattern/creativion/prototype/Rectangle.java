package designPattern.creativion.prototype;

/**
 * 描述: 接口
 *
 * @author WuYanchang
 * @date 2021/5/24 17:42
 */

public class Rectangle extends Shape{
    public Rectangle(){
        type = "Rectangle";
    }

    @Override
    public void draw() {
        System.out.println("Inside Rectangle::draw() method.");
    }
}

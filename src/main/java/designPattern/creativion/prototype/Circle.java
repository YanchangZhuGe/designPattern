package designPattern.creativion.prototype;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/5/24 17:44
 */

public class Circle extends Shape{

    public Circle(){
        type = "Circle";
    }

    @Override
    public void draw() {
        System.out.println("Inside Circle::draw() method.");
    }

}

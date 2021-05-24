package designPattern.creativion.prototype;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/5/24 17:43
 */

public class Square extends Shape {
    public Square() {
        type = "Square";
    }

    @Override
    public void draw() {
        System.out.println("Inside Square::draw() method.");
    }

}

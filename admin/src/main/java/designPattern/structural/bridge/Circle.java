package designPattern.structural.bridge;

/**
 * 描述:创建实现了 Shape 抽象类的实体类。
 *
 * @author WuYanchang
 * @date 2021/6/24 15:51
 */

public class Circle extends Shape {
    private int x, y, radius;

    public Circle(int x, int y, int radius, DrawAPI drawAPI) {
        super(drawAPI);
        this.x = x;
        this.y = y;
        this.radius = radius;
    }

    public void draw() {
        drawAPI.drawCircle(radius, x, y);
    }
}

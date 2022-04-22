package designPattern.structural.bridge;

/**
 * 描述:使用 DrawAPI 接口创建抽象类 Shape
 *
 * @author WuYanchang
 * @date 2021/6/24 15:50
 */

public abstract class Shape {
    protected DrawAPI drawAPI;

    protected Shape(DrawAPI drawAPI) {
        this.drawAPI = drawAPI;
    }

    public abstract void draw();
}

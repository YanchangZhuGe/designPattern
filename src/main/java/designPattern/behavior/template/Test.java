package designPattern.behavior.template;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/25 15:32
 */

public class Test {
    public static void main(String[] args) {

        Game game = new Cricket();
        game.play();
        System.out.println();
        game = new Football();
        game.play();
    }
}

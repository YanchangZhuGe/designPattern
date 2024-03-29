package designPattern.behavior.template;

/**
 * 描述:创建扩展了上述类的实体类。
 *
 * @author WuYanchang
 * @date 2021/6/25 15:31
 */

public class Football extends Game {

    @Override
    void endPlay() {
        System.out.println("Football Game Finished!");
    }

    @Override
    void initialize() {
        System.out.println("Football Game Initialized! Start playing.");
    }

    @Override
    void startPlay() {
        System.out.println("Football Game Started. Enjoy the game!");
    }

}

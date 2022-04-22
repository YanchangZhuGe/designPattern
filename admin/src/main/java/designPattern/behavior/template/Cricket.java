package designPattern.behavior.template;

/**
 * 描述:创建扩展了上述类的实体类。
 *
 * @author WuYanchang
 * @date 2021/6/25 15:31
 */

public class Cricket extends Game {

    @Override
    void endPlay() {
        System.out.println("Cricket Game Finished!");
    }

    @Override
    void initialize() {
        System.out.println("Cricket Game Initialized! Start playing.");
    }

    @Override
    void startPlay() {
        System.out.println("Cricket Game Started. Enjoy the game!");
    }

}

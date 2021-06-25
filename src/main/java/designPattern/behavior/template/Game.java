package designPattern.behavior.template;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/25 15:31
 */

public abstract class Game {
    abstract void initialize();
    abstract void startPlay();
    abstract void endPlay();

    //模板
    public final void play(){

        //初始化游戏
        initialize();

        //开始游戏
        startPlay();

        //结束游戏
        endPlay();
    }

}

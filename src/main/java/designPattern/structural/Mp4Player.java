package designPattern.structural;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/6/1 19:47
 */

public class Mp4Player  implements AdvancedMediaPlayer{

    @Override
    public void playVlc(String fileName) {
        //什么也不做
    }

    @Override
    public void playMp4(String fileName) {
        System.out.println("Playing mp4 file. Name: "+ fileName);
    }
}
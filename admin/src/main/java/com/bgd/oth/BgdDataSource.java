package com.bgd.oth;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2022/1/20 16:40
 */

public class BgdDataSource {

    public List findBySql(String sql, Object[] objects)
    {
        return new ArrayList<>();
    }

    public int updateBySql(String sql, Object[] objects)
    {
        return 0;
    }

    public void updateByBatchParamSql(String toString, List<Map> paramList, Object[] objects)
    {

    }
}

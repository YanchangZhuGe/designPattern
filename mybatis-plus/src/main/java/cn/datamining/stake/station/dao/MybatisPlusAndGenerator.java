package cn.datamining.stake.station.dao;

import com.baomidou.mybatisplus.generator.AutoGenerator;
import com.baomidou.mybatisplus.generator.config.DataSourceConfig;
import com.baomidou.mybatisplus.generator.config.GlobalConfig;
import com.baomidou.mybatisplus.generator.config.PackageConfig;
import com.baomidou.mybatisplus.generator.config.StrategyConfig;
import com.baomidou.mybatisplus.generator.config.rules.NamingStrategy;

public class MybatisPlusAndGenerator {
    //反向生成工具
    public static void main(String[] args) {
//创建AutoGenerator对象
        AutoGenerator mpg = new AutoGenerator();
// 全局配置
        GlobalConfig gc = new GlobalConfig();
//设置输出的路径 项目的绝对路径地址
        gc.setOutputDir("D:\\hsf-ai-operation-stake-station-api\\hsf-ai-operation-stake-station-api\\src\\main\\java\\cn\\datamining\\stake\\station\\vo");
//设置作者
        gc.setAuthor("wuyc");
        gc.setOpen(false);
//生成列
        gc.setBaseColumnList(true);
//生成result map集合
        gc.setBaseResultMap(true);
// gc.setSwagger2(true); 实体属性 Swagger2 注解
        mpg.setGlobalConfig(gc);


// 数据源配置
        DataSourceConfig dsc = new DataSourceConfig();
//连接的url地址
        dsc.setUrl("jdbc:oracle:thin:@192.168.2.109:1521:NSDEV");
// dsc.setSchemaName("public");
//设置驱动的名称
        dsc.setDriverName("oracle.jdbc.OracleDriver");
//设置mysql的用户名
        dsc.setUsername("ebs");
//设置mysql的密码
        dsc.setPassword("11111111");
//设置自动生成器的数据源
        mpg.setDataSource(dsc);

// 包配置
        PackageConfig pc = new PackageConfig();
// pc.setModuleName(scanner("模块名"));
//设置包名
        pc.setParent("com.nstc.aims.entity");
//设置自动生成器的包
        mpg.setPackageInfo(pc);


//生成策略的配置
        StrategyConfig strategyConfig = new StrategyConfig();
//生成指定表
        strategyConfig.setInclude(new String[]{"ers_elec_bill"});
//可变参数用数组，最好再模板里把它注释掉
//        strategyConfig.setTablePrefix(new String[]{""});
//驼峰命名
        strategyConfig.setNaming(NamingStrategy.underline_to_camel);
//字段驼峰命名
        strategyConfig.setColumnNaming(NamingStrategy.underline_to_camel);
//设置实体Bean的lombok
        strategyConfig.setEntityLombokModel(true);
//设置生成策略
        mpg.setStrategy(strategyConfig);

//执行自动生成器
        mpg.execute();
    }
}
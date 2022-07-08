package fixVersion;

public class SqlConst {
    public static String getAppsignSql() {
        return appsignSql;
    }

    public static String getSystemSql() {
        return systemSql;
    }

    public static String getEams_buss_property() {
        return eams_buss_property;
    }

    private static String appsignSql = "\n" +
            "INSERT INTO eams_appsign (appid, appno, appname, isenable, order_num, syscode, isdeleted) select '61700de4d44d4cb48aaf78f1299630c0', '010100000', '网银登录模块', 1, 1, '010000000', 0 from dual where not exists(select 1 from eams_appsign where appno = '010100000')\n" +
            "/\n" +
            "INSERT INTO eams_appsign (appid, appno, appname, isenable, order_num, syscode, isdeleted) select '8975befb669d4ccd9b6d2a0c487b5443', '010200000', '用户中心', 1, 1, '010000000', 0 from dual where not exists(select 1 from eams_appsign where appno = '010200000')\n" +
            "/\n" +
            "INSERT INTO eams_appsign (appid, appno, appname, isenable, order_num, syscode, isdeleted) select '2a12c357d36440f1bb88f1511d4f67bf', '010300000', '付款模块', 1, 1, '010000000', 0 from dual where not exists(select 1 from eams_appsign where appno = '010300000')\n" +
            "/\n" +
            "INSERT INTO eams_appsign (appid, appno, appname, isenable, order_num, syscode, isdeleted) select '45a084089b2b44fba23b292da4a2f36d', '010400000', '贷款模块', 1, 1, '010000000', 0 from dual where not exists(select 1 from eams_appsign where appno = '010400000')\n" +
            "/\n" +
            "INSERT INTO eams_appsign (appid, appno, appname, isenable, order_num, syscode, isdeleted) select 'b3962c5a2d54457795e85a85e70d34a3', '010500000', '存款模块', 1, 1, '010000000', 0 from dual where not exists(select 1 from eams_appsign where appno = '010500000')\n" +
            "/\n" +
            "INSERT INTO eams_appsign (appid, appno, appname, isenable, order_num, syscode, isdeleted) select '03fcc3c9b3d64b0693f05cad41748932', '010600000', '对账模块', 1, 1, '010000000', 0 from dual where not exists(select 1 from eams_appsign where appno = '010600000')\n" +
            "/\n" +
            "INSERT INTO eams_appsign (appid, appno, appname, isenable, order_num, syscode, isdeleted) select '1efb207892fc4bc29ad621d0492bafd7', '010700000', '票据模块', 1, 1, '010000000', 0 from dual where not exists(select 1 from eams_appsign where appno = '010700000')\n" +
            "/\n" +
            "INSERT INTO eams_appsign (appid, appno, appname, isenable, order_num, syscode, isdeleted) select 'c2db4e1d38e0455bbce6e7e1e5940dad', '010800000', '贸易背景模块', 1, 1, '010000000', 0 from dual where not exists(select 1 from eams_appsign where appno = '010800000')\n" +
            "/\n" +
            "INSERT INTO eams_appsign (appid, appno, appname, isenable, order_num, syscode, isdeleted) select 'a26f207d5d604528a5aa44c874c06918', '010900000', '现金管理模块', 1, 1, '010000000', 0 from dual where not exists(select 1 from eams_appsign where appno = '010900000')\n" +
            "/\n" +
            "INSERT INTO eams_appsign (appid, appno, appname, isenable, order_num, syscode, isdeleted) select 'b2bf2f58e74549f3967b1a151626b62c', '011100000', '委存贷模块', 1, 1, '010000000', 0 from dual where not exists(select 1 from eams_appsign where appno = '011100000')\n" +
            "/\n" +
            "INSERT INTO eams_appsign (appid, appno, appname, isenable, order_num, syscode, isdeleted) select 'b2bf2f58e74549f3967b1a150626b62c', '012000000', '收付汇模块', 1, 1, '010000000', 0 from dual where not exists(select 1 from eams_appsign where appno = '012000000')\n" +
            "/\n" +
            "INSERT INTO eams_appsign (appid, appno, appname, isenable, order_num, syscode, isdeleted) select '2bb398b882ea4191a6bb3b87e3446054', '013000000', '结售汇模块', 1, 1, '010000000', 0 from dual where not exists(select 1 from eams_appsign where appno = '013000000')\n" +
            "/\n" +
            "INSERT INTO eams_appsign (appid, appno, appname, isenable, order_num, syscode, isdeleted) select '68a64c68663b424db7683d77a3aeddb8', '014000000', '信用证模块', 1, 1, '010000000', 0 from dual where not exists(select 1 from eams_appsign where appno = '014000000')\n" +
            "/\n" +
            "INSERT INTO eams_appsign (appid, appno, appname, isenable, order_num, syscode, isdeleted) select '39da11edfc0f43068668b30ff47f8be7', '015000000', '头寸管理模块', 1, 1, '010000000', 0 from dual where not exists(select 1 from eams_appsign where appno = '015000000')\n" +
            "/\n" +
            "INSERT INTO eams_appsign (appid, appno, appname, isenable, order_num, syscode, isdeleted) select 'b212f820124d4f9e98256a05900cfd49', '016000000', '资金上收模块', 1, 1, '010000000', 0 from dual where not exists(select 1 from eams_appsign where appno = '016000000')\n" +
            "/\n" +
            "INSERT INTO eams_appsign (appid, appno, appname, isenable, order_num, syscode, isdeleted) select '04cee1000a824e30bb417ed5bf030e61', '017000000', '存放同业模块', 1, 1, '010000000', 0 from dual where not exists(select 1 from eams_appsign where appno = '017000000')\n" +
            "/\n" +
            "INSERT INTO eams_appsign (appid, appno, appname, isenable, order_num, syscode, isdeleted) select '6f9ee74cdbc84eba9727763388ccbcc7', '018000000', '同业拆借模块', 1, 1, '010000000', 0 from dual where not exists(select 1 from eams_appsign where appno = '018000000')\n" +
            "/\n" +
            "INSERT INTO eams_appsign (appid, appno, appname, isenable, order_num, syscode, isdeleted) select '070bf8f5330911eca252005056ba091a', '020100000', '信贷模块', 1, 1, '020000000', 0 from dual where not exists(select 1 from eams_appsign where appno = '020100000')\n" +
            "/\n" +
            "INSERT INTO eams_appsign (appid, appno, appname, isenable, order_num, syscode, isdeleted) select '070bf8f5330911eca252005056ba011a', '030100000', '融资模块', 1, 1, '030000000', 0 from dual where not exists(select 1 from eams_appsign where appno = '030100000')\n" +
            "/\n" +
            "INSERT INTO eams_appsign (appid, appno, appname, isenable, order_num, syscode, isdeleted) select '070bf8f5330911eca252005016ba091a', '050100000', '票据网银', 1, 1, '050000000', 0 from dual where not exists(select 1 from eams_appsign where appno = '050100000')\n" +
            "/\n" +
            "INSERT INTO eams_appsign (appid, appno, appname, isenable, order_num, syscode, isdeleted) select '070bf8f5330911ec2252005016ba091a', '050200000', '企业票据', 1, 1, '050000000', 0 from dual where not exists(select 1 from eams_appsign where appno = '050200000')\n" +
            "/\n" +
            "INSERT INTO eams_appsign (appid, appno, appname, isenable, order_num, syscode, isdeleted) select '070bf8f5330911ec3252005016ba091a', '050300000', '票据网关', 1, 1, '050000000', 0 from dual where not exists(select 1 from eams_appsign where appno = '050300000')\n" +
            "/\n" +
            "INSERT INTO eams_appsign (appid, appno, appname, isenable, order_num, syscode, isdeleted) select '070bf8f5330911ec4252005016ba091a', '050400000', '票据综合管理', 1, 1, '050000000', 0 from dual where not exists(select 1 from eams_appsign where appno = '050400000')\n" +
            "/";
    static String systemSql = "INSERT INTO eams_system (syscode, sysname, isdeleted) select '010000000', '新一代网银系统', 0 from dual where not exists(select 1 from eams_system where syscode = '010000000')\n" +
            "/\n" +
            "INSERT INTO eams_system (syscode, sysname, isdeleted) select '020000000', '新一代信贷系统', 0 from dual where not exists(select 1 from eams_system where syscode = '020000000')\n" +
            "/\n" +
            "INSERT INTO eams_system (syscode, sysname, isdeleted) select '030000000', '新一代G6系统', 0 from dual where not exists(select 1 from eams_system where syscode = '030000000')\n" +
            "/\n" +
            "INSERT INTO eams_system (syscode, sysname, isdeleted) select '040000000', '新一代同业授信', 0 from dual where not exists(select 1 from eams_system where syscode = '040000000')\n" +
            "/\n" +
            "INSERT INTO eams_system (syscode, sysname, isdeleted) select '050000000', '新一代票据', 0 from dual where not exists(select 1 from eams_system where syscode = '050000000')\n" +
            "/";
    static String eams_buss_property = "INSERT INTO eams_buss_property (pro_id, pro_name, pro_no, pro_value_type, buss_id, isdeleted) select '28821f28a74a41b29614cb7897e82089', '准入', 'ics.applyId', NULL, 'a23f4d54d0304f4886c60542ef46e588', 0 from dual where not exists(select 1 from eams_buss_property where pro_id =  '28821f28a74a41b29614cb7897e82089');\n" +
            "INSERT INTO eams_buss_property (pro_id, pro_name, pro_no, pro_value_type, buss_id, isdeleted) select 'fc0308b1c48d4d2a9528a3b5fa1dcd1e', '评级', 'ics.gradeId', NULL, 'c1988458cdb94d46bd162b614572319a', 0 from dual where not exists(select 1 from eams_buss_property where pro_id =  'fc0308b1c48d4d2a9528a3b5fa1dcd1e');\n" +
            "INSERT INTO eams_buss_property (pro_id, pro_name, pro_no, pro_value_type, buss_id, isdeleted) select '0fb287799ab044e38b75caacd8f92192', '准入', 'ics.applyId', NULL, 'eb4a9ede5780431e879adfd8d54473ed', 0 from dual where not exists(select 1 from eams_buss_property where pro_id =  '0fb287799ab044e38b75caacd8f92192');\n" +
            "INSERT INTO eams_buss_property (pro_id, pro_name, pro_no, pro_value_type, buss_id, isdeleted) select '2df6395d95994d7aaaa982144f1194a9', '评级', 'ics.gradeId', NULL, '74c46607c32740a1bec08420a61d75ee', 0 from dual where not exists(select 1 from eams_buss_property where pro_id =  '2df6395d95994d7aaaa982144f1194a9');\n" +
            "INSERT INTO eams_buss_property (pro_id, pro_name, pro_no, pro_value_type, buss_id, isdeleted) select '2e76505a60c64c7f8a328884ba208a6c', '授予授信', 'ics.creditArgeeNo_SYSX', NULL, '4a584e6063974c62a2bbe92a4406b4a6', 0 from dual where not exists(select 1 from eams_buss_property where pro_id =  '2e76505a60c64c7f8a328884ba208a6c');\n" +
            "INSERT INTO eams_buss_property (pro_id, pro_name, pro_no, pro_value_type, buss_id, isdeleted) select '2308783083df404e9f9e68f10145faf3', '授予授信', 'ics.creditArgeeNo_SYSX', NULL, '1e7c7ae7b9784ce7b9621a1cc80d2c73', 0 from dual where not exists(select 1 from eams_buss_property where pro_id =  '2308783083df404e9f9e68f10145faf3');\n" +
            "INSERT INTO eams_buss_property (pro_id, pro_name, pro_no, pro_value_type, buss_id, isdeleted) select '263a958fcc524b1e84f49ca0343ac288', '获得授信', 'ics.creditArgeeNo_HDSX', NULL, 'e435073b60424064ac8d07d04e42b0df', 0 from dual where not exists(select 1 from eams_buss_property where pro_id =  '263a958fcc524b1e84f49ca0343ac288');\n" +
            "INSERT INTO eams_buss_property (pro_id, pro_name, pro_no, pro_value_type, buss_id, isdeleted) select 'ccf318b85ddc493bbd14d8fbcc450d41', '获得授信', 'ics.creditArgeeNo_HDSX', NULL, '1c05cf2cb8484dac84664a7616af7cce', 0 from dual where not exists(select 1 from eams_buss_property where pro_id =  'ccf318b85ddc493bbd14d8fbcc450d41');\n" +
            "INSERT INTO eams_buss_property (pro_id, pro_name, pro_no, pro_value_type, buss_id, isdeleted) select 'bf98ecce6e29472783d7f239cd167834', '获得授信', 'ics.creditArgeeNo_HDSX', NULL, 'dd95d1e83cd04959826e3e5d08455be0', 0 from dual where not exists(select 1 from eams_buss_property where pro_id =  'bf98ecce6e29472783d7f239cd167834');\n" +
            "INSERT INTO eams_buss_property (pro_id, pro_name, pro_no, pro_value_type, buss_id, isdeleted) select '4262eeec34e5482ebc73befb3074ca14', '获得授信', 'ics.creditArgeeNo_HDSX', NULL, '4f94504f7ea74cb1889e223c5c952081', 0 from dual where not exists(select 1 from eams_buss_property where pro_id =  '4262eeec34e5482ebc73befb3074ca14');\n" +
            "INSERT INTO eams_buss_property (pro_id, pro_name, pro_no, pro_value_type, buss_id, isdeleted) select '7307418151f04b80a103647e7afb6ab4', '获得授信', 'ics.creditArgeeNo_HDSX', NULL, '131224e231874fce8c0bc025c6441941', 0 from dual where not exists(select 1 from eams_buss_property where pro_id =  '7307418151f04b80a103647e7afb6ab4');\n" +
            "INSERT INTO eams_buss_property (pro_id, pro_name, pro_no, pro_value_type, buss_id, isdeleted) select '301f09c707504f96b9cc0931f02793bb', '授予授信', 'ics.creditArgeeNo_SYSX', NULL, 'ec0b6d5c9dbf46c084094b8a8b81d6a5', 0 from dual where not exists(select 1 from eams_buss_property where pro_id =  '301f09c707504f96b9cc0931f02793bb');\n" +
            "INSERT INTO eams_buss_property (pro_id, pro_name, pro_no, pro_value_type, buss_id, isdeleted) select '427152bc832a4764885b65f5a005c58e', '获得授信', 'ics.creditArgeeNo_HDSX', NULL, '7e9aa9890f064502b5e945bb28718c1f', 0 from dual where not exists(select 1 from eams_buss_property where pro_id =  '427152bc832a4764885b65f5a005c58e');\n" +
            "INSERT INTO eams_buss_property (pro_id, pro_name, pro_no, pro_value_type, buss_id, isdeleted) select 'a463c897bc6946f99b4b476caf9869f8', '授予授信', 'ics.creditArgeeNo_SYSX', NULL, '2eeab15c29234ec79fcefa4af3c04430', 0 from dual where not exists(select 1 from eams_buss_property where pro_id =  'a463c897bc6946f99b4b476caf9869f8');\n" +
            "INSERT INTO eams_buss_property (pro_id, pro_name, pro_no, pro_value_type, buss_id, isdeleted) select 'f0ae1201d5394344807ceb551d6b54cd', '授予授信', 'ics.creditArgeeNo_SYSX', NULL, '40fcaaa7cb3e4553af5b5f4a188cd143', 0 from dual where not exists(select 1 from eams_buss_property where pro_id =  'f0ae1201d5394344807ceb551d6b54cd');\n" +
            "INSERT INTO eams_buss_property (pro_id, pro_name, pro_no, pro_value_type, buss_id, isdeleted) select '7a27c5f0277b441f876615a204edf141', '授予授信', 'ics.creditArgeeNo_SYSX', NULL, '32702b49a90f49889e70732b0ed1c346', 0 from dual where not exists(select 1 from eams_buss_property where pro_id =  '7a27c5f0277b441f876615a204edf141');\n" +
            "INSERT INTO eams_buss_property (pro_id, pro_name, pro_no, pro_value_type, buss_id, isdeleted) select '93a57819893948f3a1f47545d973495f', '授予授信', 'ics.creditArgeeNo_SYSX', NULL, '0ab6070daa014e2293730f9966dcfc7d', 0 from dual where not exists(select 1 from eams_buss_property where pro_id =  '93a57819893948f3a1f47545d973495f');\n" +
            "INSERT INTO eams_buss_property (pro_id, pro_name, pro_no, pro_value_type, buss_id, isdeleted) select '73999f1239aa446992b2cd71607f3351', '授予授信', 'ics.creditArgeeNo_SYSX', NULL, '8f9503e04611461db2144730bf5ed66f', 0 from dual where not exists(select 1 from eams_buss_property where pro_id =  '73999f1239aa446992b2cd71607f3351');\n";
}

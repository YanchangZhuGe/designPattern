package com.bgp.mcs.service.common;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.IAutoRunBean;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * 标题：东方地球物理公司物探生产管理系统
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：屈克将
 *       
 * 描述：启动时从selectLib.xml和codeLib.xml加载下拉框的数据
 */
public class CodeSelectOptionsSrv extends BaseService implements IAutoRunBean {

	private ILog log;
    private IJdbcDao jdbcDao;
    
    public CodeSelectOptionsSrv()
    {
        log = LogFactory.getLogger(CodeSelectOptionsSrv.class);
        jdbcDao = BeanFactory.getPureJdbcDAO();
    }
    
	/* (non-Javadoc)
	 * @see com.cnpc.jcdp.common.IAutoRunBean#run()
	 */
	public void run() {
		
		log.debug("SelectOptionsSrv init ! ");
		
		SAXReader reader = new SAXReader();
		Document doc;
		Element root;
		
		try {
			doc = reader.read(CodeSelectOptionsSrv.class.getClassLoader().getResourceAsStream("selectLib.xml"));
			root = doc.getRootElement();
			Element select;
			Element option;
			for (Iterator i = root.elementIterator("Select"); i.hasNext();) {
				select = (Element)i.next();
				
				List optionList = new ArrayList();
				for(Iterator j = select.elementIterator("option");j.hasNext();){
					option = (Element)j.next();
					Map map = new HashMap();
					map.put("value", option.attributeValue("value"));
					map.put("label", option.getText());
					optionList.add(map);
				}

				CodeSelectOptionsUtil.addOption(select.attributeValue("name"), optionList);
			}
			
		} catch (DocumentException e) {
			log.debug("read selectLib.xml failed! ");
		}
		
		log.debug("read selectLib.xml success! ");

		try {
			doc = reader.read(CodeSelectOptionsSrv.class.getClassLoader().getResourceAsStream("codeLib.xml"));
			root = doc.getRootElement();
			Element code;
			String sql = "";
			for (Iterator i = root.elementIterator("Code"); i.hasNext();) {
				code = (Element)i.next();
				sql = code.attributeValue("sql");
				
				if(sql==null || sql.equals("")) continue;
				
				List optionList = jdbcDao.queryRecords(sql);
				
				CodeSelectOptionsUtil.addOption(code.attributeValue("name"), optionList);
			}
			
		} catch (DocumentException e) {
			log.debug("read codeLib.xml failed! ");
		}
		
		log.debug("read codeLib.xml success! ");
			
	}
	
	public ISrvMsg getCodeSelectOption(ISrvMsg reqDTO) throws Exception {

		return CodeSelectOptionsUtil.getAllOptions(reqDTO);
	}

	public ISrvMsg getCodeSelectOptionByName(ISrvMsg reqDTO) throws Exception {

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		msg.setValue("option", CodeSelectOptionsUtil.getOptionByName(reqDTO.getValue("optionName")));
		
		return msg;
	}
	
}

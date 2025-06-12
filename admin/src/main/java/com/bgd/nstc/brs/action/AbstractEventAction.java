package com.nstc.brs.action;

import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;


import com.nstc.framework.action.EventAction;
import com.nstc.framework.core.Caller;
import com.nstc.framework.dto.BizEvent;
import com.nstc.framework.dto.BizEventResponse;
import com.nstc.framework.exception.AppException;
import com.nstc.brs.util.TypeCastUtils;
import com.nstc.util.BeanUtils;

/**
 * ������¼�������
 * 
 * @author kevin.lee
 * 
 */
public abstract class AbstractEventAction implements EventAction {

	protected Caller caller;

	public final BizEventResponse execute(Caller caller, BizEvent event) throws AppException {
		this.caller = caller;
		BizEventResponse response = null;
		try {
			response = perform(caller, event);
		} catch (Exception e) {
			throw new AppException(e);
		}
		if (response == null) {
			response = new BizEventResponse();
		}

		return response;
	}

	/**
	 * ����Ӧ��ָ������Ӧ���key����������ת��ΪMap
	 * 
	 * @param key
	 * @param list
	 * @return
	 */
	protected BizEventResponse buildResponse(String key, Object obj) throws Exception {
		BizEventResponse response = new BizEventResponse(true);
		return buildResponse(response, key, obj);
	}

	/**
	 * ����Ӧ��ָ������Ӧ���key����������ת��ΪMap
	 * 
	 * @param key
	 * @param list
	 * @return
	 */
	protected BizEventResponse buildResponse(BizEventResponse response, String key, Object obj) throws Exception {
		Object result = new Object();
		if (TypeCastUtils.isBaseObjectType(obj)) {
			result = obj;
		} else if (obj instanceof Map) {
			Map m = (Map) obj;
			Set ks = m.keySet();
			for (Iterator iterator = ks.iterator(); iterator.hasNext();) {
				Object k = (Object) iterator.next();
				Object v = m.get(k);
				if (TypeCastUtils.isBaseObjectType(v)) {
					m.put(k, v);
				} else {
					m.put(k, BeanUtils.describe(m.get(k)));
				}
			}
			result = m;
		} else if (obj instanceof List) {
			List l = (List) obj;
			result = BeanUtils.describe(l);
		} else {
			result = BeanUtils.describe(obj);
		}

		if (key == null || "".equals(key)) {
			response.put(result);
		} else {
			response.put(key, result);
		}
		return response;
	}

	/**
	 * ����Ӧ�𣬲�ָ������Ӧ���key����������ת��ΪMap
	 * 
	 * @param list
	 * @return
	 */
	protected BizEventResponse buildResponse(Object obj) throws Exception {
		return buildResponse("", obj);
	}

	/**
	 * ����Ӧ����
	 * 
	 * @param response
	 * @param obj
	 * @return
	 * @throws Exception
	 */
	protected BizEventResponse appendResponse(BizEventResponse response, String key, Object obj) throws Exception {
		return buildResponse(response, key, obj);
	}

	/**
	 * ����������
	 * 
	 * @param caller
	 * @param event
	 * @return
	 * @throws Exception
	 */
	public abstract BizEventResponse perform(Caller caller, BizEvent event) throws Exception;

}

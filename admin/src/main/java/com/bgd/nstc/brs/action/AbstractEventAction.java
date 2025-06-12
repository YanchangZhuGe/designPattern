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
 * 抽象的事件处理类
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
	 * 构建应答，指定返回应答的key，并将参数转换为Map
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
	 * 构建应答，指定返回应答的key，并将参数转换为Map
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
	 * 构建应答，不指定返回应答的key，并将参数转换为Map
	 * 
	 * @param list
	 * @return
	 */
	protected BizEventResponse buildResponse(Object obj) throws Exception {
		return buildResponse("", obj);
	}

	/**
	 * 增加应答结果
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
	 * 动作处理类
	 * 
	 * @param caller
	 * @param event
	 * @return
	 * @throws Exception
	 */
	public abstract BizEventResponse perform(Caller caller, BizEvent event) throws Exception;

}

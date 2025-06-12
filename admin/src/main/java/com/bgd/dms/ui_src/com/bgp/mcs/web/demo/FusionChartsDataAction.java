package com.bgp.mcs.web.demo;

import java.io.OutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;

public class FusionChartsDataAction extends WSAction {

	@Override
	public ActionForward executeResponse(ActionMapping arg0, ActionForm arg1,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		response.setContentType("text/xml; charset=UTF-8");
		
		OutputStream os = response.getOutputStream();
		
		os.write(new byte[] { (byte) 0xEF, (byte) 0xBB, (byte) 0xBF });
		
		os.write("<chart caption='²âÊÔ' xAxisName='Week' yAxisName='Sales' numberPrefix='$'>".getBytes("UTF-8"));
		
		os.write("<set label='ÖÜ 1' value='14400' /> <set label='Week 2' value='19600' />".getBytes("UTF-8"));
		
		os.write("<set label='Week 2' value='19600' /> <set label='Week 3' value='24000' />".getBytes("UTF-8"));
		
		os.write("<set label='Week 3' value='24000' /> <set label='Week 4' value='15700' /> </chart>".getBytes("UTF-8"));
		
		os.write("</chart>".getBytes("UTF-8"));
		
		os.flush();
		
		return null;
	}
}

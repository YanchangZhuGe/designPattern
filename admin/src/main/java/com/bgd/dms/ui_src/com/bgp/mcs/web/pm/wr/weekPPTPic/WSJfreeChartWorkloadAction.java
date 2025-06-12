package com.bgp.mcs.web.pm.wr.weekPPTPic;

import java.awt.BasicStroke;
import java.awt.Color;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.annotations.CategoryTextAnnotation;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.labels.StandardCategoryItemLabelGenerator;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.renderer.category.LineAndShapeRenderer;
import org.jfree.chart.title.LegendTitle;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.ui.RectangleEdge;
import org.jfree.ui.RectangleInsets;
import org.jfree.ui.TextAnchor;

import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MsgElement;
import com.cnpc.jcdp.webapp.constant.MVCConstant;
import com.cnpc.jcdp.webapp.util.JcdpMVCUtil;

@SuppressWarnings({ "rawtypes" })
public class WSJfreeChartWorkloadAction extends WSAction {
	public void setDTOValue(ISrvMsg requestDTO, ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		if (requestDTO == null)
			return;
		setRequestValuesToDTO(requestDTO, mapping, form, request, response);
	}

	@SuppressWarnings("unchecked")
	public ActionForward executeResponse(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		ISrvMsg respMsg = JcdpMVCUtil.getResponseMsg(request);
		Map map = respMsg.getMsgElement("chartArgs").toMap();
		List<MsgElement> listMsg = respMsg.getMsgElements("listA");
		List listA = new ArrayList();
		for (int i = 0; listMsg != null && i < listMsg.size(); i++) {
			Map mapInfo = listMsg.get(i).toMap();
			listA.add(mapInfo);
		}
		Map mapA=new HashMap();
		mapA.put("list", listA);
		mapA.put("year2D", map.get("year2D"));
		mapA.put("year3D", map.get("year3D"));
		mapA.put("titleName", map.get("titleName"));
		JFreeChart chartA = getChartByMap(mapA);
		
		List<MsgElement> listMsgB = respMsg.getMsgElements("listB");
		List listB = new ArrayList();
		for (int i = 0; listMsgB != null && i < listMsgB.size(); i++) {
			Map mapInfo = listMsgB.get(i).toMap();
			listB.add(mapInfo);
		}
		Map mapB=new HashMap();
		mapB.put("list", listB);
		mapB.put("year2D", map.get("week2D"));
		mapB.put("year3D", map.get("week3D"));
		mapB.put("titleName", map.get("titleName"));
		JFreeChart chartB = getChartByMap(mapB);
		chartB.getTitle().setText("");
		request.setAttribute("chartA", chartA);
		request.setAttribute("chartB", chartB);
		if (respMsg.isSuccessRet())
			return mapping.findForward(MVCConstant.FORWARD_SUCESS);
		else {
			return mapping.findForward(MVCConstant.FORWARD_FAILED);
		}
	}

	public JFreeChart getChartByMap(Map map) throws NumberFormatException, ParseException {
		List list = (List) map.get("list");
		
		String titleName = (String) map.get("titleName");
		String year2D = (String) map.get("year2D");
		String year3D = (String) map.get("year3D");
		
		DefaultCategoryDataset dataset = new DefaultCategoryDataset();

		if (list != null) {
			for (int i = 0; i < list.size(); i++) {
				Map dataMap = (Map) list.get(i);
				dataset.addValue(Double.parseDouble((String) dataMap.get("complete2dMoney")), "二维", (String) dataMap.get("weekDate"));
				dataset.addValue(Double.parseDouble((String) dataMap.get("complete3dMoney")), "三维", (String) dataMap.get("weekDate"));
			}
		}

		JFreeChart chart = ChartFactory.createLineChart(titleName, "日期", "工作量", dataset, PlotOrientation.VERTICAL, true, true, true);
		chart.setBackgroundPaint(Color.white);
		CategoryPlot plot = (CategoryPlot) chart.getCategoryPlot();
		
		LegendTitle legend = chart.getLegend(0);
		legend.setPosition(RectangleEdge.RIGHT);
		
		//设置拐点的标注
		if (list != null&&list.size()>0) {
			Map dataMap = (Map) list.get(list.size() - 1);
			CategoryTextAnnotation newInfoAnno = new CategoryTextAnnotation(year2D, (String) dataMap.get("weekDate"),
					Double.parseDouble((String) dataMap.get("complete2dMoney")));
			CategoryTextAnnotation completeMoneyAllAnno = new CategoryTextAnnotation(year3D,
					(String) dataMap.get("weekDate"), Double.parseDouble((String) dataMap.get("complete3dMoney")));
			newInfoAnno.setTextAnchor(TextAnchor.BASELINE_LEFT);
			completeMoneyAllAnno.setTextAnchor(TextAnchor.BASELINE_LEFT);
			plot.addAnnotation(newInfoAnno);
			plot.addAnnotation(completeMoneyAllAnno);
		}
		plot.setBackgroundPaint(Color.white);// 设置网格背景色
		plot.setDomainGridlinePaint(Color.LIGHT_GRAY);// 设置网格竖线(Domain轴)颜色
		plot.setRangeGridlinePaint(Color.LIGHT_GRAY);// 设置网格横线颜色
		plot.setAxisOffset(new RectangleInsets(5.0, 5.0, 5.0, 5.0));// 设置曲线图与xy轴的距离
		plot.setRangeCrosshairVisible(true);
		LineAndShapeRenderer renderer = (LineAndShapeRenderer) plot.getRenderer();

		// 设置拐点是否可见
		renderer.setShapesVisible(true);
		// 设置拐点使用不同的形状
		renderer.setDrawOutlines(true);
		// 设置折现以及拐点的宽度
		renderer.setSeriesStroke(0, new BasicStroke(3F));
		renderer.setSeriesOutlineStroke(0, new BasicStroke(2.0F));
		org.jfree.chart.labels.CategoryItemLabelGenerator generator = new StandardCategoryItemLabelGenerator("{2}", new DecimalFormat("0") // 调整显示的数字和字符格式
		);
		// 拐点的数据是否可见
		renderer.setBaseItemLabelGenerator(generator);
		renderer.setBaseItemLabelsVisible(true);
		//
		// 设置显示值的小数点个数
		NumberAxis numAxis = (NumberAxis) plot.getRangeAxis();
		NumberFormat numFormater = NumberFormat.getNumberInstance();
		numFormater.setMinimumFractionDigits(0);
		numAxis.setUpperMargin(0.1);
		numAxis.setNumberFormatOverride(numFormater);

		// 设置X轴
		//CategoryAxis axis = (CategoryAxis) plot.getDomainAxis();
		return chart;
	}

}
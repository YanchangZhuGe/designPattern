package com.bgp.mcs.web.pm.wr.weekPPTPic;

import java.awt.BasicStroke;
import java.awt.Color;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.ParseException;
import java.util.ArrayList;
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
public class WSJfreeChartAction extends WSAction {
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
		String week_date = respMsg.getValue("week_date");
		String chartname = respMsg.getValue("chartname");
		List<MsgElement> listMsg = respMsg.getMsgElements("resultList");
		List list = new ArrayList();
		for (int i = 0; listMsg != null && i < listMsg.size(); i++) {
			Map mapInfo = listMsg.get(i).toMap();
			list.add(mapInfo);
		}
		map.put("resultList", list);
		JFreeChart chart = getChartByMap(map);
		request.setAttribute("chart", chart);
		request.setAttribute("week_date", week_date);
		request.setAttribute("chartname", chartname);
		if (respMsg.isSuccessRet())
			return mapping.findForward(MVCConstant.FORWARD_SUCESS);
		else {
			return mapping.findForward(MVCConstant.FORWARD_FAILED);
		}
	}

	public JFreeChart getChartByMap(Map map) throws NumberFormatException, ParseException {
		List list = (List) map.get("resultList");
		String titleName = (String) map.get("titlename");
		String carryAllInfo = (String) map.get("carryAllInfo");
		String newInfo = (String) map.get("newInfo");
		String completeMoneyAllInfo = (String) map.get("completeInfo");
		DefaultCategoryDataset dataset = new DefaultCategoryDataset();

		if (list != null) {
			for (int i = 0; i < list.size(); i++) {
				Map dataMap = (Map) list.get(i);
				dataset.addValue(Double.parseDouble((String) dataMap.get("budgetMoney")), "ָ��", (String) dataMap.get("weekDate"));
				dataset.addValue(Double.parseDouble((String) dataMap.get("carryout")), "�ۼ��г���ʵ", (String) dataMap.get("weekDate"));
				dataset.addValue(Double.parseDouble((String) dataMap.get("newGet")), "��ǩ�г���ʵ", (String) dataMap.get("weekDate"));
				dataset.addValue(Double.parseDouble((String) dataMap.get("completeMoney")), "��ɼ�ֵ����", (String) dataMap.get("weekDate"));
			}
		}

		JFreeChart chart = ChartFactory.createLineChart(titleName, "����", "������", dataset, PlotOrientation.VERTICAL, true, true, true);
		chart.setBackgroundPaint(Color.white);
		CategoryPlot plot = (CategoryPlot) chart.getCategoryPlot();
		
		LegendTitle legend = chart.getLegend(0);
		legend.setPosition(RectangleEdge.BOTTOM);
		
		//���ùյ�ı�ע
		if (list != null&&list.size()>0) {
			Map dataMap = (Map) list.get(list.size() - 1);
			CategoryTextAnnotation carryAllInfoAnno = new CategoryTextAnnotation(carryAllInfo, (String) dataMap.get("weekDate"),
					Double.parseDouble((String) dataMap.get("carryout")));
			CategoryTextAnnotation newInfoAnno = new CategoryTextAnnotation(newInfo, (String) dataMap.get("weekDate"),
					Double.parseDouble((String) dataMap.get("newGet")));
			CategoryTextAnnotation completeMoneyAllAnno = new CategoryTextAnnotation(completeMoneyAllInfo,
					(String) dataMap.get("weekDate"), Double.parseDouble((String) dataMap.get("completeMoney")));
			carryAllInfoAnno.setTextAnchor(TextAnchor.TOP_LEFT);
			newInfoAnno.setTextAnchor(TextAnchor.BASELINE_LEFT);
			completeMoneyAllAnno.setTextAnchor(TextAnchor.BASELINE_LEFT);
			plot.addAnnotation(carryAllInfoAnno);
			plot.addAnnotation(newInfoAnno);
			plot.addAnnotation(completeMoneyAllAnno);
		}
		plot.setBackgroundPaint(Color.white);// �������񱳾�ɫ
		plot.setDomainGridlinePaint(Color.LIGHT_GRAY);// ������������(Domain��)��ɫ
		plot.setRangeGridlinePaint(Color.LIGHT_GRAY);// �������������ɫ
		plot.setAxisOffset(new RectangleInsets(5.0, 5.0, 5.0, 5.0));// ��������ͼ��xy��ľ���
		plot.setRangeCrosshairVisible(true);
		LineAndShapeRenderer renderer = (LineAndShapeRenderer) plot.getRenderer();

		// ���ùյ��Ƿ�ɼ�
		renderer.setShapesVisible(true);
		// ���ùյ�ʹ�ò�ͬ����״
		renderer.setDrawOutlines(true);
		// ���������Լ��յ�Ŀ��
		renderer.setSeriesStroke(0, new BasicStroke(3F));
		renderer.setSeriesOutlineStroke(0, new BasicStroke(2.0F));
		org.jfree.chart.labels.CategoryItemLabelGenerator generator = new StandardCategoryItemLabelGenerator("{2}", new DecimalFormat("0") // ������ʾ�����ֺ��ַ���ʽ
		);
		// �յ�������Ƿ�ɼ�
		renderer.setBaseItemLabelGenerator(generator);
		renderer.setBaseItemLabelsVisible(true);
		//
		// ������ʾֵ��С�������
		NumberAxis numAxis = (NumberAxis) plot.getRangeAxis();
		NumberFormat numFormater = NumberFormat.getNumberInstance();
		numFormater.setMinimumFractionDigits(0);
		numAxis.setNumberFormatOverride(numFormater);

		// ����X��
		//CategoryAxis axis = (CategoryAxis) plot.getDomainAxis();
		return chart;
	}

}
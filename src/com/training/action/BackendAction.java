package com.training.action;

import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.struts.action.*;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.upload.FormFile;

import com.training.formbean.GoodsBean;
import com.training.formbean.SearchForm;
import com.training.model.Goods;
import com.training.model.GoodsSearch;
import com.training.service.BackendService;
import com.training.vo.SalesReport;

public class BackendAction extends DispatchAction {
	
	private BackendService backendService = BackendService.getInstance();

//重新進入後台or商品搜尋頁面時，清除之前的搜尋條件
	public ActionForward queryAllGoods(ActionMapping mapping, ActionForm form, 
			HttpServletRequest request, HttpServletResponse response)
			throws Exception{
		HttpSession session = request.getSession();
		session.removeAttribute("SearchCondition");
		session.removeAttribute("TotalPages");
		return mapping.findForward("SearchGoods");
	}
	
//設定搜尋條件
	public ActionForward setSearchCondition(ActionMapping mapping, ActionForm form, 
			HttpServletRequest request, HttpServletResponse response)
			throws Exception{
		SearchForm searchForm = (SearchForm) form;
		GoodsSearch search = new GoodsSearch();
		BeanUtils.copyProperties(search,searchForm);
		HttpSession session = request.getSession();
		session.setAttribute("SearchCondition", search);
		return mapping.findForward("SearchGoods");
	}
	
//執行搜尋 換頁只重新執行搜尋 不更新條件
	public ActionForward searchGoodsList(ActionMapping mapping, ActionForm form, 
			HttpServletRequest request, HttpServletResponse response)
			throws Exception{
//		SearchForm searchForm = (SearchForm) form;
//		GoodsSearch search = new GoodsSearch();
//		BeanUtils.copyProperties(search,searchForm);
		HttpSession session = request.getSession();
		GoodsSearch search = null;
		if(null != session.getAttribute("SearchCondition")){
			search= (GoodsSearch) session.getAttribute("SearchCondition");
		}else{
			search = new GoodsSearch();
			search.setOrderByPrice("ID");
			search.setStatus(-1);
		}
		
		int currentPage=1;
		if(null!=request.getParameter("pageNo") && !request.getParameter("pageNo").equals("0")){
			currentPage= Integer.parseInt(request.getParameter("pageNo"));
		}
		
		List<Goods> allList = backendService.searchGoods(search);
		
		List<Goods> goodsList = null;
		if(currentPage*10 < allList.size()){
			goodsList = allList.subList((currentPage-1)*10, currentPage*10);	
		}else{
			goodsList = allList.subList((currentPage-1)*10, allList.size());
		}
//		System.out.println("商品總數："+goodsList.size());
//		goodsList.stream().forEach(g->System.out.println(g));
//		System.out.println();
		session.setAttribute("ResultList", goodsList);
		int total = ((allList.size()-1)/10)+1;
		session.setAttribute("TotalPages", total);
		
		List<Integer> showPages = new ArrayList<>();
		for(int i=currentPage-2; i<=currentPage+2;++i){
			if(i>0 && i<=total){
				showPages.add(i);
			}
		}
		session.setAttribute("showPages", showPages);
		
		return mapping.findForward("GoodsListView");
	}
	
	public ActionForward goodsListView(ActionMapping mapping, ActionForm form, 
			HttpServletRequest request, HttpServletResponse response)
			throws Exception{
		return mapping.findForward("GoodsListView");
	}
	
	public ActionForward addGoods(ActionMapping mapping, ActionForm form, 
			HttpServletRequest request, HttpServletResponse response)
			throws Exception{
		
		GoodsBean goodsbean = (GoodsBean) form;
		goodsbean.setGoodsID(new BigDecimal("0"));
		Goods gd = new Goods();
		BeanUtils.copyProperties(gd, goodsbean);
		
		//先處理圖片
		FormFile file = goodsbean.getGoodsImage();
		String fileName = file.getFileName();
		gd.setGoodsImageName(fileName);
        FileOutputStream fileOutput = new FileOutputStream("C:/home/VendingMachine/DrinksImage/" 
        		+ fileName); 

        fileOutput.write(file.getFileData()); 
        fileOutput.flush(); 
        fileOutput.close(); 
        file.destroy() ;
		
		int goodsID = backendService.createGoods(gd);
		String msg = "";
		if(goodsID > 0){ 
			msg = "商品新增上架成功！";
//			System.out.println("商品新增上架成功！");
		}else{
			msg = "錯誤 - 新增商品失敗";
		}
		
		HttpSession session = request.getSession();
		session.setAttribute("updateMsg", msg);
		
		return mapping.findForward("GoodsCreate");
	}
	
	public ActionForward goodsCreateView(ActionMapping mapping, ActionForm form, 
			HttpServletRequest request, HttpServletResponse response)
			throws Exception{
		return mapping.findForward("GoodsCreateView");
	}
	
	public ActionForward updateGoods(ActionMapping mapping, ActionForm form, 
			HttpServletRequest request, HttpServletResponse response)
			throws Exception{
		
		GoodsBean goodsbean = (GoodsBean) form;
		Goods gd = new Goods();
		BeanUtils.copyProperties(gd, goodsbean);
		
		boolean updateSuccess = backendService.updateGoods(gd);
		String msg = updateSuccess ? "商品維護作業成功！" : "發生錯誤 商品維護未完成";
//		if(updateSuccess){
//			System.out.println("商品維護作業成功！"); 
//		}
		HttpSession session = request.getSession();
		session.setAttribute("updateMsg", msg);
		
		return mapping.findForward("GoodsReplenishment");
	}
	
	public ActionForward goodsReplenishmentView(ActionMapping mapping, ActionForm form, 
			HttpServletRequest request, HttpServletResponse response)
			throws Exception{
		List<Goods> allGoods = backendService.queryGoods();
		HttpSession session = request.getSession();
		session.setAttribute("allGoods", allGoods);
		
//		String id = request.getParameter("goodsID");
//		id = (id != null) ? id : (String)request.getSession().getAttribute("selectedID");
//		if(id != null){
//			Goods goods = backendService.queryGoodsByID(Integer.parseInt(id));
//			request.setAttribute("selectedGoods", goods);
//		}
		
		return mapping.findForward("GoodsReplenishmentView");
	}
	
	public ActionForward goodsReplenishmentAjax(ActionMapping mapping, ActionForm form, 
			HttpServletRequest request, HttpServletResponse response)
			throws Exception{
		String id = request.getParameter("goodsID");
		Goods goods = null;
		if(id != null){
			goods = backendService.queryGoodsByID(Integer.parseInt(id));
		}
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		out.println(JSONObject.fromObject(goods));
		out.flush();
		out.close();
		
		return null;
	}
	
	public ActionForward querySalesReport(ActionMapping mapping, ActionForm form, 
			HttpServletRequest request, HttpServletResponse response)
			throws Exception{
		String queryStartDate = request.getParameter("queryStartDate");
		String queryEndDate = request.getParameter("queryEndDate");
		
		Set<SalesReport> reports = backendService.queryOrderBetweenDate(queryStartDate, queryEndDate);
		request.setAttribute("salesReports", reports);
		request.setAttribute("startDate", request.getParameter("queryStartDate"));
		request.setAttribute("endDate", request.getParameter("queryEndDate"));
		
//		reports.stream().forEach(g->System.out.println(g));
		
		return mapping.findForward("GoodsSaleReport");
	}
	
	public ActionForward goodsSaleReportView(ActionMapping mapping, ActionForm form, 
			HttpServletRequest request, HttpServletResponse response)
			throws Exception{
		return mapping.findForward("GoodsSaleReport");
	}
	
	public ActionForward gotoFrontend(ActionMapping mapping, ActionForm form, 
			HttpServletRequest request, HttpServletResponse response)
			throws Exception{
		return mapping.findForward("Frontend");
	}
}

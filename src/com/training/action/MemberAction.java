package com.training.action;

//import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;





import java.util.Set;


//import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
//import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;

import com.training.dao.FrontendDao;
import com.training.formbean.GoodsOrderForm;
import com.training.model.Goods;

@MultipartConfig
public class MemberAction extends DispatchAction{
	
	FrontendDao frontendDao = FrontendDao.getInstance(); 

	public ActionForward addCartGoods(ActionMapping mapping, ActionForm form, 
			HttpServletRequest request, HttpServletResponse response)
			throws Exception{
		GoodsOrderForm order = (GoodsOrderForm) form;
		String goodsID = order.getGoodsID();
		String buyQuantity = order.getBuyQuantity();
		
//		String goodsID = request.getParameter("goodsID");
//		String buyQuantity = request.getParameter("buyQuantity");		
		System.out.println("goodsID:" + goodsID);
		System.out.println("buyQuantity:" + buyQuantity);	
		
		if(Integer.parseInt(buyQuantity)<=0){
			return mapping.findForward("VendingMachine_RD");
		}
		
		// 查詢資料庫商品並且加入購物車
		Goods goods = frontendDao.queryBuyGoods(new BigDecimal(goodsID)); 
		
		Map<Goods, Integer> cartGoods = new LinkedHashMap<>();
		cartGoods.put(goods, Integer.parseInt(buyQuantity));
		
		HttpSession session = request.getSession();
		if(session.getAttribute("cartGoods")!=null){
			Map<Goods, Integer> sessionCart = (Map<Goods, Integer>)session.getAttribute("cartGoods");
			if(sessionCart.keySet().contains(goods)){
				sessionCart.replace(goods, sessionCart.get(goods)+cartGoods.get(goods));
			}else{
				sessionCart.put(goods, cartGoods.get(goods));
			}
		}else{
			session.setAttribute("cartGoods" , cartGoods);
		}
		System.out.println("已將 "+goods.getGoodsName()+" "+cartGoods.get(goods)+"個 加入購物車");
		return mapping.findForward("VendingMachine_RD");
	}
	
//	public ActionForward toCart(ActionMapping mapping, ActionForm form, 
//			HttpServletRequest request, HttpServletResponse response) throws Exception{
//		return mapping.findForward("Cart");
//	}
	
	public ActionForward queryCartGoods(ActionMapping mapping, ActionForm form, 
			HttpServletRequest request, HttpServletResponse response) throws Exception{
		// 列出商品名稱、購買數量
		// 購物車商品總金額
		HttpSession session = request.getSession();
		if(session.getAttribute("cartGoods")!=null){			
			//重新查詢商品
			updateGoodsInfo(request);
		}
		
		return mapping.findForward("Cart");
	}
	
	//重新查詢商品
	public void updateGoodsInfo(HttpServletRequest request){
		HttpSession session = request.getSession();
		
		int total=0;
		Map<Goods, Integer> cart = (Map<Goods, Integer>)session.getAttribute("cartGoods");
		Map<Goods, Integer> reQueryCart = new HashMap<>();
		
		for(Goods gd : cart.keySet()){
			Goods reQueryGoods = frontendDao.queryBuyGoods(gd.getGoodsID());
			reQueryCart.put(reQueryGoods, cart.get(gd));
			total += cart.get(gd) * reQueryGoods.getGoodsPrice();
		}
		session.removeAttribute("cartTotal");
		session.removeAttribute("cartGoods");
		session.setAttribute("cartTotal", total);
		session.setAttribute("cartGoods",reQueryCart);
	}
	
	public ActionForward clearCartGoods(ActionMapping mapping, ActionForm form, 
			HttpServletRequest request, HttpServletResponse response) throws Exception{
		// 清空購物車
		clearCartGoods(request);
//		System.out.println("已清空購物車");
		return mapping.findForward("Cart");
	}
	
	private static void clearCartGoods(HttpServletRequest request) {
		HttpSession session = request.getSession();
		session.removeAttribute("cartGoods");
	}
	
}

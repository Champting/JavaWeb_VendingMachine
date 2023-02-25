package com.training.action;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.HttpSession;

import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;








//import com.training.dao.FrontEndDao;
import com.training.model.Goods;
import com.training.model.Member;
//import com.training.model.Member;
import com.training.service.FrontendService;
import com.training.vo.BuyGoodsRtn;
import com.training.vo.Receipt;

public class FrontendAction extends DispatchAction{
	
	FrontendService frontendService = FrontendService.getInstance();
	
	public ActionForward searchGoods(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
			throws Exception{
		int pageNo = (null != request.getParameter("pageNo")) ? Integer.parseInt(request.getParameter("pageNo")) : 1;
		String keyWord = (null != request.getParameter("searchKeyword")) ? request.getParameter("searchKeyword") : "";
		List<Goods> goods = null;
		
		//取出所有符合搜尋條件的商品
		goods = frontendService.searchGoods(keyWord);
		
		//販賣機 商品頁面 尺寸 (方便日後調整頁面)
		int rowNum = 2;
		int colNum = 3;
		int pageNum = rowNum * colNum;
		
		//本頁顯示的起/終點
		int startRowNo = (pageNo-1)*pageNum;
		int endRowNo = (goods.size()>(pageNo*pageNum))?(pageNo*pageNum):goods.size();
		List<Goods> goodsInPage = goods.subList(startRowNo, endRowNo);//要顯示的內容
		
		//重新包成二維陣列
		List<List<Goods>> goodsTable = new ArrayList<>();
		int count = 0;
		for(int i=0; i<rowNum; ++i){
			goodsTable.add(new ArrayList<>());
			for(int j=0; j<colNum; ++j){
				if(count < goodsInPage.size()){
					goodsTable.get(i).add(goodsInPage.get(count++));
				}else{
					break;
				}
			}
		}
		request.setAttribute("resultTable", goodsTable);
		
		//總頁數 ("最後一頁" 用)
		int totalPages = (goods.size()-1)/pageNum +1;
		request.setAttribute("TotalPages", totalPages);
		
		//翻頁/選擇頁數用 顯示本頁和前後各兩頁(最多5頁)
		List<Integer> showPageNumber = new ArrayList<>();
		for(int p = pageNo-2; p <= pageNo+2; ++p){
			if(p>0 && p<=totalPages){
				showPageNumber.add(p);
			}
		}
		request.setAttribute("showPageNumber", showPageNumber);
		
//		goods.stream().forEach(g -> System.out.println(g));
//		System.out.println("--------------------------------------------");
        
        return mapping.findForward("VendingMachine");
	}
	
	public ActionForward buyGoods(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
			throws Exception{
		HttpSession session = request.getSession();
		Member member = (Member)session.getAttribute("member");
		String customerID = member.getIdentificationNo();
		
		if(session.getAttribute("cartGoods")!=null){
			updateGoodsInfo(request);
			
			Map<Goods, Integer> cart = (Map<Goods, Integer>)session.getAttribute("cartGoods");
			List<String> idList = new ArrayList<>();
			List<String> qtList = new ArrayList<>();
			
			for(Goods gd : cart.keySet()){
				idList.add(gd.getGoodsID().toString());
				qtList.add(cart.get(gd).toString());
			}
			
			String[] goodsIDs = idList.toArray(new String[0]);
			String[] quantities = qtList.toArray(new String[0]);
			
			int inputMoney = Integer.parseInt(request.getParameter("inputMoney"));
			
			BuyGoodsRtn buyInfo = frontendService.buyGoods(customerID, goodsIDs, quantities, inputMoney);
			session.setAttribute("reciept", buyInfo);
			if(buyInfo.getInputMoney()!=buyInfo.getChangeMoney()){
				session.removeAttribute("cartGoods");
			}
			
			
		}else{
			System.out.println("購物車內沒有商品");
		}
		
//		System.out.println("--------------------------------------------");
		
//		session.removeAttribute("cartGoods");
		
		return mapping.findForward("Cart_RD");
	}
	
	public void updateGoodsInfo(HttpServletRequest request){
		HttpSession session = request.getSession();
		
		int total=0;
		Map<Goods, Integer> cart = (Map<Goods, Integer>)session.getAttribute("cartGoods");
		Map<Goods, Integer> reQueryCart = new HashMap<>();
		
		for(Goods gd : cart.keySet()){
			Goods reQueryGoods = frontendService.queryBuyGoods(gd.getGoodsID());
			reQueryCart.put(reQueryGoods, cart.get(gd));
			total += cart.get(gd) * reQueryGoods.getGoodsPrice();
		}
		session.removeAttribute("cartTotal");
		session.removeAttribute("cartGoods");
		session.setAttribute("cartTotal", total);
		session.setAttribute("cartGoods",reQueryCart);
	}
	
	public ActionForward vendingMachineView(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
			throws Exception{
		return mapping.findForward("VendingMachine");
	}
	
	public ActionForward gotoBackend(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
			throws Exception{
		return mapping.findForward("Backend");
	}
	
}

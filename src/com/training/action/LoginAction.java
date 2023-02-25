package com.training.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;

import com.training.model.Member;
import com.training.service.FrontendService;

public class LoginAction extends DispatchAction{
	FrontendService frontendService = FrontendService.getInstance();
	
	public ActionForward login(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
			throws Exception{
		// 登入請求
    	ActionForward actFwd = null;
    	String loginMsg = "";
    	HttpSession session = request.getSession();
    	String inputID = request.getParameter("id");
        String inputPwd = request.getParameter("pwd");
        // 依使用者所輸入的帳戶名稱取得 Member
        Member member = frontendService.login(inputID);
    	if(member != null) {
    		// Step3:取得帳戶後進行帳號、密碼比對
    		String id = member.getIdentificationNo();    		
    		String pwd = member.getPassword();
    		if(id.equals(inputID) && pwd.equals(inputPwd)) {
    			
//    			System.out.println(member.getCustomerName() + " 先生/小姐您好!");
//    			loginMsg = member.getCustomerName() + " 先生/小姐您好!";
    			
    			// 將account存入session scope 以供LoginCheckFilter之後使用!
    			session.setAttribute("member", member);
    			actFwd = mapping.findForward("Success");        			
    		} else {
                // Step4:帳號、密碼錯誤,轉向到 "/Login.jsp" 要求重新登入.
    			
    			System.out.println("帳號或密碼錯誤");
    			loginMsg = "帳號或密碼錯誤";
    			actFwd = mapping.findForward("Fail");
    		}
    	} else {
            // Step5:無此帳戶名稱,轉向到 "/Login.jsp" 要求重新登入.
    		
    		System.out.println("無此帳戶名稱,請重新輸入!");
    		loginMsg = "無此帳戶名稱,請重新輸入!";
    		actFwd = mapping.findForward("Fail");
    	}
    	request.setAttribute("loginMsg", loginMsg);
    	return actFwd;
	}
	
	public ActionForward loginRedirect(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
			throws Exception{
		return mapping.findForward("Frontend");
	}
	
	
	public ActionForward logout(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
			throws Exception{
		HttpSession session = request.getSession();
		session.removeAttribute("member");
		session.removeAttribute("carGoods");
		
		System.out.println("已登出");
		request.setAttribute("loginMsg", "已登出");
		return mapping.findForward("Fail");
	}
}

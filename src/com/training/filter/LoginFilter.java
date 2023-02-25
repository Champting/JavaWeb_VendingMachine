package com.training.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
//import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.training.model.Member;

/**
 * Servlet Filter implementation class LoginFilter
 */
public class LoginFilter implements Filter {

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest httpRequest = (HttpServletRequest)request;
		HttpSession session = httpRequest.getSession();
		
		Member member = (Member)session.getAttribute("member");
		// 判斷session裡是否有使用者登入資訊
		if(member != null){
			// 已登入(放行)
			chain.doFilter(request, response);
		}else{
			// 是否為登入請求
			String requestURI = httpRequest.getRequestURI();
			String action = httpRequest.getParameter("action");
			if(requestURI.endsWith("LoginAction.do") && "login".equals(action) ){
				chain.doFilter(request, response);
			}else{
				// 未登入(導回登入頁)
				HttpServletResponse httpResponse = (HttpServletResponse)response;
				httpResponse.sendRedirect("Login.jsp");			
			}
		}
	}
	
	
	
	/**
     * Default constructor. 
     */
    public LoginFilter() { }

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() { }

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException { }

}

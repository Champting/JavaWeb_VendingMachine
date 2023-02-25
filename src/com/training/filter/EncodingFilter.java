package com.training.filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

/**
 * Servlet Filter implementation class EncodingFilter
 */
public class EncodingFilter implements Filter {

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		// 解决 POST请求參數值中文亂碼問題
    	request.setCharacterEncoding("UTF-8");
		
		// 設置服務輸出的編碼為UTF-8
		response.setCharacterEncoding("UTF-8");
		// 設置瀏覽器輸出的內容是html,並且以utf-8的編碼來查看這個內容
		response.setContentType("text/html; charset=utf-8");
		
		chain.doFilter(request, response);
	}

    /**
     * Default constructor. 
     */
    public EncodingFilter() { }

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {	}
	
	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException { }

}

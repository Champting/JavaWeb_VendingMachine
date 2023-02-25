<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>販賣機</title>
<style type="text/css">
.page {
	display: inline-block;
	padding-left: 10px;
}
</style>
<script type="text/javascript">
	function addCartGoods(goodsID, buyQuantityIdx) {
		console.log("goodsID:", goodsID);
		var buyQuantity = document.getElementsByName("buyQuantity")[buyQuantityIdx].value;
		console.log("buyQuantity:", buyQuantity);
		const
		formData = new FormData();
		formData.append('action', 'addCartGoods');
		formData.append('goodsID', goodsID);
		formData.append('buyQuantity', buyQuantity);
		// 送出商品加入購物車請求
		const
		request = new XMLHttpRequest();
		request.open("POST", "MemberAction.do");
		request.send(formData);
	}
// 	function queryCartGoods() {
// 		const
// 		formData = new FormData();
// 		formData.append('action', 'queryCartGoods');
// 		// 送出查詢購物車商品請求
// 		const
// 		request = new XMLHttpRequest();
// 		request.open("POST", "MemberAction.do");
// 		request.send(formData);
// 	}

</script>
</head>
<body align="center">
<table width="1000" height="400" align="center">
	<tr>
		<td colspan="2" align="right">
						
		</td>
	</tr>
	<tr>
		<td colspan="2" align="right">
			<form action="FrontendAction.do" method="get">
				<input type="hidden" name="action" value="searchGoods"/>
				<input type="hidden" name="pageNo" value="1"/>
				<input type="text" name="searchKeyword"/>
				<input type="submit" value="商品查詢"/>
			</form>
		</td>
	</tr>
	<tr>
		<td width="400" height="200" align="center">		
			<img border="0" src="DrinksImage/coffee.jpg" width="200" height="200" >			
			<h1>歡迎光臨，${sessionScope.member.customerName}</h1>		
			<a href="FrontendAction.do?action=gotoBackend" align="left" >後臺頁面</a>&nbsp; &nbsp;
			<a href="LoginAction.do?action=logout" align="left">登出</a>
			<br/><br/>
			<a href="MemberAction.do?action=queryCartGoods">購物車</a>
		</td>
		<%	
			if(null!=request.getParameter("pageNo")){
				pageContext.setAttribute("pageNo", request.getParameter("pageNo"));	
			}else{
				pageContext.setAttribute("pageNo",1);
			}
			if(null!=request.getParameter("searchKeyword")){
				pageContext.setAttribute("searchKeyword", request.getParameter("searchKeyword"));	
			}
		
			int index =0;
		%>
		<td width="600" height="400">	
			<table border="1" style="border-collapse: collapse">
				<c:forEach items="${resultTable}" var="row">
					<tr>
					<c:forEach items="${row}" var="goods">
						<td width="300">							
						<font face="微軟正黑體" size="5" >
							<!-- 例如: 可口可樂 30元/罐 -->	
							${goods.goodsName}
						</font>
						<br/>
						<font face="微軟正黑體" size="4" style="color: gray;" >
							<!-- 例如: 可口可樂 30元/罐 -->	
							${goods.goodsPrice} 元/罐  
						</font>
						<br/>
						<!-- 各商品圖片 -->
						<img border="0" src="DrinksImage/${goods.goodsImageName}" width="150" height="150" >						
						<br/>
						<font face="微軟正黑體" size="3">
							<input type="hidden" name="goodsID" value="${goods.goodsID}">
							<!-- 設定最多不能買大於庫存數量 -->
							購買<input type="number" name="buyQuantity" min="0" max="${goods.goodsQuantity}" size="5" value="0">罐
							<br><br><button onclick="addCartGoods(${goods.goodsID},<%=index++%>)">加入購物車</button>
							<% %>
							<!-- 顯示庫存數量 -->
							<br><p <c:if test="${goods.goodsQuantity eq 0}">style="color: red;" 
									</c:if>>(庫存 ${goods.goodsQuantity} 罐)</p>
						</font>
					</td>
					</c:forEach>
					</tr>
				</c:forEach>		
			</table>
		</td>		
	</tr>
	
	<c:if test="${TotalPages gt '1'}">
	<tr>
		<td colspan="2" align="right">				
			<c:if test="${pageNo gt '1'}">
				<h3 class="page"> <a href="FrontendAction.do?action=searchGoods&pageNo=1&searchKeyword=${searchKeyword}"> <c:out value="<<"/> </a> </h3>
				<h3 class="page"> <a href="FrontendAction.do?action=searchGoods&pageNo=${pageNo-1}&searchKeyword=${searchKeyword}"> <c:out value="<"/> </a> </h3>
			</c:if>
			<c:forEach items="${showPageNumber}" var="pn">
				<h3 class="page"><a href="FrontendAction.do?action=searchGoods&pageNo=${pn}&searchKeyword=${searchKeyword}" 
						<c:if test="${pageNo eq pn}">style="color: red;font-weight: bold;"</c:if>> ${pn} </a>
				</h>
			</c:forEach>
			<c:if test="${pageNo lt TotalPages}">
				<h3 class="page"> <a href="FrontendAction.do?action=searchGoods&pageNo=${pageNo+1}&searchKeyword=${searchKeyword}"> <c:out value=">"/> </a> </h3>
				<h3 class="page"> <a href="FrontendAction.do?action=searchGoods&pageNo=${TotalPages}&searchKeyword=${searchKeyword}"> <c:out value=">>"/> </a> </h3>
			</c:if>
		</td>
	</tr>
	</c:if>
</table>

</body>
</html>
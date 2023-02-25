<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>販賣機 - 購物車</title>
<script type="text/javascript">
function clearCartGoods() {
	const
	formData = new FormData();
	formData.append('action', 'clearCartGoods');
	// 送出清空購物車商品請求
	const
	request = new XMLHttpRequest();
	request.open("POST", "MemberAction.do");
	request.send(formData);
}
</script>
</head>
<body align="center">
<table width="1000" height="400" align="center">
	<tr>
	<td align="right" colspan="2"><a href="FrontendAction.do?action=searchGoods">繼續購物</a></td>
	</tr>
	<tr>
	<td></td>
	<td align="left"><a href="MemberAction.do?action=clearCartGoods">清除購物車內容</a></td> 
	</tr>
	<tr>
		<td width="400" height="200" align="center">		
			<img border="0" src="DrinksImage/coffee.jpg" width="200" height="200" >			
			<h1>歡迎光臨，${sessionScope.member.customerName}</h1>		
			<a href="FrontendAction.do?action=gotoBackend" align="left" >後臺頁面</a>&nbsp; &nbsp;
			<a href="LoginAction.do?action=logout" align="left">登出</a>
			<br/><br/>
			<form action="FrontendAction.do" method="post">
				<input type="hidden" name="action" value="buyGoods"/>				
				<font face="微軟正黑體" size="4" >
					<b>投入:</b>
					<input type="number" name="inputMoney" max="100000" min="0"  size="5" value="0">
					<b>元</b>		
					<b><input type="submit" value="送出">					
					<br/><br/>
				</font>
			</form>
			<c:if test="${not empty reciept}">
			<div style="border-width:3px;border-style:dashed;border-color:#FFAC55;
				padding:5px;width:300px;">
				<p style="color: blue;">~~~~~~~ 消費明細 ~~~~~~~</p>
				<p style="margin: 10px;">
					投入金額：${reciept.inputMoney}
				</p>
				<p style="margin: 10px;">
					購買金額：${reciept.buyMoney}
				</p>
				<p style="margin: 10px;">
					找零金額：${reciept.changeMoney}
				</p>
				<c:forEach items="${reciept.goods}" var="detail">
					<p style="margin: 10px;">
						${detail.goodsName}: <fmt:formatNumber type="number" pattern="$ #,###." 
								value="${detail.goodsPrice}"/> * ${detail.goodsQuantity}
					</p>
				</c:forEach>	
			</div>
			</c:if>
		</td>
		<td align="center" width="900">
			<c:choose>
				<c:when test="${fn:length(cartGoods) eq '0'}">購物車內沒有商品</c:when>
				<c:otherwise>
				<table>
					<tr>
					<td>#</td><td width="450">商品名稱</td><td width="50">數量</td><td width="70">單價</td>
					</tr>
					<c:forEach items="${cartGoods}" var="goods" varStatus="status">
						<tr>
						<td>${status.index + 1}</td>
						<td>${goods.key.goodsName}</td>
						<td>${goods.value}</td>
						<td>${goods.key.goodsPrice}</td>
						</tr>
					</c:forEach>
					<tr>
						<td colspan="4" align="right"><br>總計： <fmt:formatNumber value="${cartTotal}" type="number" pattern="$ #,###."/></td>
					</tr>
				</table>
				</c:otherwise>
			</c:choose>
		</td>		
	</tr>
	
	
</table>

</body>
</html>
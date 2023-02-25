<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>販賣機-後臺 銷售報表</title>
</head>
<body>
	<%@ include file="VM_Backend_Navigation.jsp" %>

	<h2>銷售報表</h2><br/>
	<div style="margin-left:25px;">
	<form action="BackendAction.do" method="get">
		<input type="hidden" name="action" value="querySalesReport"/>
		起 &nbsp; <input type="date" name="queryStartDate" style="height:25px;width:180px;font-size:16px;text-align:center;"
			value="${startDate}"/>
		&nbsp;
		迄 &nbsp; <input type="date" name="queryEndDate" style="height:25px;width:180px;font-size:16px;text-align:center;"
			value="${endDate}"/>	
		<input type="submit" value="查詢" style="margin-left:25px; width:50px;height:32px"/>
	</form>
	<c:if test="${not empty salesReports}">共 ${fn:length(salesReports) } 筆資料</c:if><br/>
	<table border="1">
		<tbody>
			<tr height="50">
				<td width="100"><b>訂單編號</b></td>
				<td width="100"><b>顧客姓名</b></td>
				<td width="100"><b>購買日期</b></td>
				<td width="125"><b>飲料名稱</b></td> 
				<td width="100"><b>購買單價</b></td>
				<td width="100"><b>購買數量</b></td>
				<td width="100"><b>購買金額</b></td>
			</tr>
			<c:forEach items="${salesReports}" var="rpt">
				<tr height="30">
					<td>${rpt.orderID}</td>
					<td>${rpt.customerName}</td>
					<td>${rpt.orderDate}</td>
					<td>${rpt.goodsName}</td>
					<td><fmt:formatNumber type="number" value="${rpt.goodsBuyPrice}" pattern="$ #,###."/></td> 
					<td><fmt:formatNumber type="number" value="${rpt.buyQuantity}" pattern="#,###"/></td>
					<td><fmt:formatNumber type="number" value="${rpt.buyAmount}" pattern="$ #,###."/></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	</div>
</body>
</html>
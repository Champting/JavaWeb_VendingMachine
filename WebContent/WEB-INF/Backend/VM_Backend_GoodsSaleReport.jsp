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
<div class="container">
	<c:set var="currentPage" value="report"/>
	<%@ include file="VM_Backend_Navigation.jsp" %>
	<div class="row">
		<v class="col my-4"><h2>銷售報表</h2>
	</div>
	<div class="row">
		<div class="col my-2">
			<form class="form-inline" action="BackendAction.do" method="get">
				<input type="hidden" name="action" value="querySalesReport"/>
				起 &nbsp; <input class="form-control" type="date" name="queryStartDate" 
					value="${startDate}"/>
				&nbsp;&nbsp;
				迄 &nbsp; <input class="form-control" type="date" name="queryEndDate"
					value="${endDate}"/>	
				<input type="submit" class="btn btn-outline-secondary ml-4" value="查詢" />
			</form>
		</div>
	</div>
	<div class="row">
		<div class="col my-2">
		<c:if test="${not empty salesReports}">共 ${fn:length(salesReports) } 筆資料</c:if><br/>
		<table class="table table-striped table-hover">
			<thead class="thead-dark">
				<tr>
					<th scope="col">#</th>
					<th scope="col">訂單編號</th>
					<th scope="col">顧客姓名</th>
					<th scope="col">購買日期</th>
					<th scope="col">飲料名稱 </th>
					<th scope="col">購買單價</th>
					<th scope="col">購買數量</th>
					<th scope="col">購買金額</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${salesReports}" var="rpt" varStatus="status">
					<tr height="30">
						<th scope="row">${status.index+1}</th>
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
	</div>
</div>
</body>
</html>
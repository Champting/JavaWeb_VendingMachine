<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<c:url value="/" var="WEB_PATH"/>
<c:url value="/js" var="JS_PATH"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>販賣機-後臺 商品維護</title>
	
	<script src="${JS_PATH}/jquery-1.11.1.min.js"></script>
	<script type="text/javascript">
	$(document).ready(function(){
		
		$("#selectGoods").bind("change",function(){

			var goodsID = $("#selectGoods option:selected").val();
			if("" != goodsID){
				var passObj = {
					goodsID : goodsID
				};
				
				$.ajax({
					url: '${WEB_PATH}BackendAction.do?action=goodsReplenishmentAjax',
					type: "GET",
					data: passObj,
					success: function(goodsInfo){
						$("#idPrice").val(goodsInfo.goodsPrice);
						$("#idStatus").val(goodsInfo.status).change();
					}
				});
			}else{
				$("#idPrice").val("");
				$("#idStatus").val('0').change();
			}

// 			  error: function(error) { // 請求發生錯誤時執行函式
// 			  	alert("Ajax Error!");
// 			  }
// 			});
// 		}else{
// 		  	$("#accountName").val('');
// 		  	$("#accountPwd").val('');
// 		  	$("#balanceDiv").empty();
// 		}
		//
			
			
		});
	});
	

	</script>
</head>
<body>
	<%@ include file="VM_Backend_Navigation.jsp" %>

	<h2>商品維護作業</h2><br/>
	<div style="color: blue; font-weight: bold; height: 15px;">${updateMsg}</div>
	<%session.removeAttribute("updateMsg"); %>
	<div  style="margin-left:25px;">
	<form name="updateGoodsForm" action="BackendAction.do" method="post">
		<input type="hidden" name="action" value="updateGoods"/>
		<p>
			飲料名稱：
			 <select size="1" name="goodsID" id="selectGoods">
				<option value="">----請選擇----</option>
				<c:forEach items="${allGoods}" var="goods">
					<option value="${goods.goodsID}" <c:if test="${selectedGoods.goodsID eq goods.goodsID}">selected</c:if>>
						${goods.goodsName}</option>
				</c:forEach>
			</select>
		</p>		
		<p>
			更改價格： 
			<input type="number" id="idPrice" name="goodsPrice" size="5"  min="0">
		</p>
		<p>
			補貨數量：
			<input type="number" id="idReplenish" name="goodsQuantity" size="5" value="0" min="0" max="1000">
		</p>
		<p>
			商品狀態：
			<select id="idStatus" name="status">
				<option value="1" >上架</option>
				<option value="0" >下架</option>				
			</select>
		</p>
		<p>
			<input type="submit" value="送出">
		</p>
	</form>
	</div>
</body>
</html>
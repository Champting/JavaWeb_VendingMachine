<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=BIG5">
	<title>登入</title>
</head>
<body>
	<form action="LoginAction.do" method="post">
		<input type="hidden" name="action" value="login">
			<table style="margin: 0  auto">
				<tr><td colspan="2" style="font-weight: bold; font-size: 40px; text-align: center;" ><br>WELCOME!!</td></tr>
				<tr><td colspan="2" style="font-size: 24px; text-align: center;" ><br>請先登入<br><br></td></tr>
				<tr><td colspan="2" style="color: red; text-align: center;">${requestScope.loginMsg}</td></tr>
				<tr><td style="padding: 5px;">UESR</td><td><input type="text" name="id"></td></tr>
				<tr><td style="padding: 5px;">PASSWORD</td><td><input type="password" name="pwd"></td></tr> 
				<tr><td></td><td align=right><input type="submit" value="LOG IN" ></td>
			</table>
	</form>
</body>
</html>
<%--
  Created by IntelliJ IDEA.
  User: XYC
  Date: 2019/4/9
  Time: 17:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
    <title>Title</title>
</head>
<body>
$.ajax({
type:"",
url:"",
data:{

},
async:true,
success:function (data) {

},
error: function () {
    alert("服务器维护中...")
},
dataType:"json"
})

String createBy = ((User) request.getSession().getAttribute("user")).getName();
String createTime = DateTimeUtil.getSysTime();

String editBy = ((User) request.getSession().getAttribute("user")).getName();
String editTime = DateTimeUtil.getSysTime();
</body>
</html>

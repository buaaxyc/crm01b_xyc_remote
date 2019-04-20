<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <%--<meta charset="UTF-8">--%>
    <base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/"/>
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script>
        $(
            function () {
                //清空账号,密码,提示信息栏并将光标定位至账号栏
                $("#loginAct").val("")
                $("#loginPwd").val("")
                $("#msg").html("")
                $("#loginAct").focus()

                //为登录按钮和键盘按下enter事件绑定登录
                $("#submitBtn").bind("click", login)
                $(window).bind("keydown", function (event) {
                    // alert("keyCode = " + event.keyCode) //按F12弹窗后无法调出控制台
                    if (event.keyCode == 13) {
                        login()
                    }
                })

                if (window.top != window) {
                    window.top.location = window.location
                }
            }
        )

        function login() {
            // alert("提交登录中...")
            var loginAct = $.trim($("#loginAct").val())
            var loginPwd = $.trim($("#loginPwd").val())

            if (loginAct == "" || loginPwd == "") {
                $("#msg").html("账号或密码不能为空！")
                return
            }

            $.ajax({
                type: "post",
                url: "settings/user/login.do",
                data: {
                    "loginAct": loginAct,
                    "loginPwd": loginPwd
                },
                async: true,
                success: function (data) {
                    // alert(data)
                    if (data.success) {
                        // alert("登录成功！")
                        window.location = "workbench/index.jsp"
                    } else {
                        $("#msg").html(data.msg)
                    }
                },
                error: function (data) {
                    alert("服务器维护中...")
                },
                dataType: "json"
            })
        }
    </script>
</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
    <img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
        CRM &nbsp;<span style="font-size: 12px;">&copy;2017&nbsp;动力节点</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录</h1>
        </div>
        <form action="workbench/index.jsp" class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input class="form-control" type="text" placeholder="用户名" id="loginAct">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input class="form-control" type="password" placeholder="密码" id="loginPwd">
                </div>
                <div class="checkbox" style="position: relative;top: 30px; left: 10px;">

                    <span id="msg" style="color: red"></span>

                </div>
                <button type="button" class="btn btn-primary btn-lg btn-block"
                        style="width: 350px; position: relative;top: 45px;" id="submitBtn">登录
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
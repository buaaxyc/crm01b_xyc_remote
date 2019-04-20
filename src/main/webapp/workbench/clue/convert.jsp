<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/"/>
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <script type="text/javascript">
        $(function () {
            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "top-left"
            });

            $("#isCreateTransaction").click(function () {
                if (this.checked) {
                    $("#create-transaction2").show(200);
                } else {
                    $("#create-transaction2").hide(200);
                }
            });

            //为模态窗口搜索框的键盘敲击绑定条件查询事件
            $("#aname").keydown(function (event) {
                if (event.keyCode == 13) {

                    showActivityByCondition()

                    return false
                }
            })

            //为模态窗口的小放大镜绑定条件查询事件
            $("#searchBtn").click(showActivityByCondition)

            //为模态窗口的提交按钮绑定事件
            $("#submitBtn").click(function () {

                var $xz = $(":radio[name=xz]:checked")

                if ($xz.length == 0) {
                    alert("请选择需要提交的市场活动")
                } else {

                    var activityId = $xz.val()

                    $("#activityId").val(activityId)

                    var activityName = $("#n" + activityId).html()

                    $("#activityName").val(activityName)

                    //赋值完毕后清空
                    $("#aname").val("")

                    $("#activitySearchBody").empty()

                    //隐藏模态窗口
                    $("#searchActivityModal").modal("hide")
                }
            })

            //为转换按钮绑定线索转换事件
            $("#convertBtn").click(function () {
                if ($("#isCreateTransaction").prop("checked")) {

                    //需要创建交易，使用表单提交
                    $("#tranForm").submit()
                } else {

                    //不需要创建交易，使用window.location
                    window.location.href = "workbench/clue/convert.do?clueId=${param.id}"
                }
            })
        });

        function showActivityByCondition() {
            $.ajax({
                type: "get",
                url: "workbench/clue/getActivityListByName.do",
                data: {
                    "aname": $.trim($("#aname").val())
                },
                async: true,
                success: function (data) {
                    var html = ""

                    $.each(data, function (i, n) {
                        html += '<tr>'
                        html += '<td><input type="radio" name="xz" value="' + n.id + '"/></td>'
                        html += '<td id="n' + n.id + '">' + n.name + '</td>'
                        html += '<td>' + n.startDate + '</td>'
                        html += '<td>' + n.endDate + '</td>'
                        html += '<td>' + n.owner + '</td>'
                        html += '</tr>'
                    })

                    $("#activitySearchBody").html(html)

                },
                error: function () {
                    alert("服务器维护中...")
                },
                dataType: "json"
            })
        }
    </script>

</head>
<body>

<!-- 搜索市场活动的模态窗口 -->
<div class="modal fade" id="searchActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">搜索市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" id="aname" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询">
                            <a href="javascript:void(0)" id="searchBtn">
                                <span class="glyphicon glyphicon-search"></span>
                            </a>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="activitySearchBody">
                    <%--<tr>--%>
                    <%--<td><input type="radio" name="activity"/></td>--%>
                    <%--<td>发传单</td>--%>
                    <%--<td>2020-10-10</td>--%>
                    <%--<td>2020-10-20</td>--%>
                    <%--<td>zhangsan</td>--%>
                    <%--</tr>--%>
                    <%--<tr>--%>
                    <%--<td><input type="radio" name="activity"/></td>--%>
                    <%--<td>发传单</td>--%>
                    <%--<td>2020-10-10</td>--%>
                    <%--<td>2020-10-20</td>--%>
                    <%--<td>zhangsan</td>--%>
                    <%--</tr>--%>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="submitBtn">提交</button>
            </div>
        </div>
    </div>
</div>

<div id="title" class="page-header" style="position: relative; left: 20px;">
    <h4>转换线索
        <small>${param.fullname}${param.appellation}-${param.company}</small>
    </h4>
</div>
<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
    新建客户：${param.company}
</div>
<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
    新建联系人：${param.fullname}${param.appellation}
</div>
<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
    <input type="checkbox" id="isCreateTransaction"/>
    为客户创建交易
</div>
<div id="create-transaction2"
     style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;">

    <form action="workbench/clue/convert.do" method="post" id="tranForm">

        <input type="hidden" name="flag" value="true">

        <input type="hidden" name="clueId" value="${param.id}">

        <div class="form-group" style="width: 400px; position: relative; left: 20px;">
            <label for="amountOfMoney">金额</label>
            <input type="text" class="form-control" id="amountOfMoney" name="money">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="tradeName">交易名称</label>
            <input type="text" class="form-control" id="tradeName" value="${param.company}-" name="name">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="expectedClosingDate">预计成交日期</label>
            <input type="text" class="form-control time" id="expectedClosingDate" readonly name="expectedDate">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="stage">阶段</label>
            <select id="stage" class="form-control" name="stage">
                <option></option>
                <%--<option>资质审查</option>--%>
                <%--<option>需求分析</option>--%>
                <%--<option>价值建议</option>--%>
                <%--<option>确定决策者</option>--%>
                <%--<option>提案/报价</option>--%>
                <%--<option>谈判/复审</option>--%>
                <%--<option>成交</option>--%>
                <%--<option>丢失的线索</option>--%>
                <%--<option>因竞争丢失关闭</option>--%>
                <c:forEach items="${applicationScope.stageList}" var="s">
                    <option value="${s.value}">${s.text}</option>
                </c:forEach>
            </select>
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="activityName">市场活动源&nbsp;&nbsp;
                <a href="javascript:void(0);" data-toggle="modal" data-target="#searchActivityModal"
                   style="text-decoration: none;">
                    <span class="glyphicon glyphicon-search"></span>
                </a>
            </label>
            <input type="text" class="form-control" id="activityName" placeholder="点击上面搜索" readonly>
            <input type="hidden" id="activityId" name="activityId">
        </div>
    </form>

</div>

<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
    记录的所有者：<br>
    <b>${param.owner}</b>
</div>
<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
    <input class="btn btn-primary" type="button" value="转换" id="convertBtn">
    &nbsp;&nbsp;&nbsp;&nbsp;
    <input class="btn btn-default" type="button" value="取消" onclick="window.history.back()">
</div>
</body>
</html>
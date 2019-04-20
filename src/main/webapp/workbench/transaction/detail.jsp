<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="com.bjpowernode.crm.settings.domain.DicValue" %>
<%@ page import="com.bjpowernode.crm.workbench.domain.Tran" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

    List<DicValue> stageList = (List<DicValue>) application.getAttribute("stageList");

    Map<String, String> pMap = (Map<String, String>) application.getAttribute("pMap");

    int point = 0;

    for (int i = 0; i < stageList.size(); i++) {
        String stage = stageList.get(i).getValue();

        String possibility = pMap.get(stage);

        if ("0".equals(possibility)) { //注意：要通过for遍历取得分界点下标，则查询stageList时必须按orderNo升序，且阶段与可能性的对应关系必须为stage从小到大对应possibility从非0到0
            point = i;

            break;
        }
    }


    //获取当前交易的阶段、可能性、对应下标index
    Tran t = (Tran) request.getAttribute("t");

    String currentStage = t.getStage();

    String currentPossibility = pMap.get(currentStage);

    int index = 0;

    for (int i = 0; i < stageList.size(); i++) {
        String listStage = stageList.get(i).getValue();

        if (currentStage.equals(listStage)) {
            index = i;

            break;
        }
    }

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/"/>
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>

    <style type="text/css">
        .mystage {
            font-size: 20px;
            vertical-align: middle;
            cursor: pointer;
        }

        .closingDate {
            font-size: 15px;
            cursor: pointer;
            vertical-align: middle;
        }
    </style>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {
            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function () {
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });

            $(".remarkDiv").mouseover(function () {
                $(this).children("div").children("div").show();
            });

            $(".remarkDiv").mouseout(function () {
                $(this).children("div").children("div").hide();
            });

            $(".myHref").mouseover(function () {
                $(this).children("span").css("color", "red");
            });

            $(".myHref").mouseout(function () {
                $(this).children("span").css("color", "#E6E6E6");
            });


            //阶段提示框
            $(".mystage").popover({
                trigger: 'manual',
                placement: 'bottom',
                html: 'true',
                animation: false
            }).on("mouseenter", function () {
                var _this = this;
                $(this).popover("show");
                $(this).siblings(".popover").on("mouseleave", function () {
                    $(_this).popover('hide');
                });
            }).on("mouseleave", function () {
                var _this = this;
                setTimeout(function () {
                    if (!$(".popover:hover").length) {
                        $(_this).popover("hide")
                    }
                }, 100);
            });

            showHistory()

        });

        function showHistory() {
            $.ajax({
                type: "get",
                url: "workbench/transaction/getHistoryListByTranId.do",
                data: {
                    "tranId": "${t.id}"
                },
                async: true,
                success: function (data) {
                    var html = ""

                    $.each(data, function (i, n) {
                        html += '<tr>'
                        html += '<td>' + n.stage + '</td>'
                        html += '<td>' + n.money + '</td>'
                        html += '<td>' + n.possibility + '</td>'
                        html += '<td>' + n.expectedDate + '</td>'
                        html += '<td>' + n.createTime + '</td>'
                        html += '<td>' + n.createBy + '</td>'
                        html += '</tr>'
                    })

                    $("#historyBody").html(html)

                },
                error: function () {
                    alert("服务器维护中...")
                },
                dataType: "json"
            })
        }

        //变更交易阶段
        function changeStage(listStage, i) {
            // alert(i + " : " + listStage)
            $.ajax({
                type: "post",
                url: "workbench/transaction/changeStage.do",
                data: {
                    "id": "${t.id}",
                    "stage": listStage,
                    "money": "${t.money}",
                    "expectedDate": "${t.expectedDate}"
                },
                async: true,
                success: function (data) {
                    //data:{"success":?,"t":{交易对象t}}

                    if (data.success) {

                        //局部刷新页面中的交易详情信息
                        // $("#stage").html(listStage)
                        $("#stage").html(data.t.stage)
                        $("#possibility").html(data.t.possibility)
                        $("#editBy").html(data.t.editBy)
                        $("#editTime").html(data.t.editTime)

                        //刷新交易历史列表
                        showHistory()

                        //更新阶段图标
                        changeIcon(i)
                    } else {
                        alert(data.msg)
                    }
                },
                error: function () {
                    alert("服务器维护中...")
                },
                dataType: "json"
            })

        }

        function changeIcon(index) {

            //index为变更后阶段的下标

            var point = "<%=point%>"

            //方法二：使用分界点point的写法
            if (index >= point) {
                //当前阶段为后2个阶段，前7个为黑圈，后2个一个红叉一个黑叉

                //遍历前7个阶段图标
                for (var i = 0; i < point; i++) {
                    var $icon = $("#" + i)

                    //黑圈
                    $icon.removeClass()
                    $icon.addClass("glyphicon glyphicon-record mystage")
                    $icon.css("color", "black")

                }

                //遍历后2个阶段图标
                for (var i = point; i < <%=stageList.size()%>; i++) {
                    var $icon = $("#" + i)

                    if (i == index) {
                        //红叉
                        $icon.removeClass()
                        $icon.addClass("glyphicon glyphicon-remove mystage")
                        $icon.css("color", "red")
                    } else {
                        //黑叉
                        $icon.removeClass()
                        $icon.addClass("glyphicon glyphicon-remove mystage")
                        $icon.css("color", "black")
                    }
                }


            } else {
                //当前阶段为前7个阶段，前7个为绿圈、绿色标记、黑圈，后2个都是黑叉

                //遍历前7个阶段图标
                for (var i = 0; i < point; i++) {
                    var $icon = $("#" + i)

                    if (i == index) {
                        //绿色标记
                        $icon.removeClass()
                        $icon.addClass("glyphicon glyphicon-map-marker mystage")
                        $icon.css("color", "#90F790")

                    } else if (i < index) {
                        //绿圈
                        $icon.removeClass()
                        $icon.addClass("glyphicon glyphicon-ok-circle mystage")
                        $icon.css("color", "#90F790")

                    } else {
                        //黑圈
                        $icon.removeClass()
                        $icon.addClass("glyphicon glyphicon-record mystage")
                        $icon.css("color", "black")
                    }

                }

                //遍历后2个阶段图标
                for (var i = point; i < <%=stageList.size()%>; i++) {
                    var $icon = $("#" + i)

                    //黑叉
                    $icon.removeClass()
                    $icon.addClass("glyphicon glyphicon-remove mystage")
                    $icon.css("color", "black")
                }
            }

        }

    </script>

</head>
<body>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>${t.customerId}-${t.name}
            <small>￥${t.money}</small>
        </h3>
    </div>
    <div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default"
                onclick="window.location.href='workbench/transaction/edit.jsp';"><span
                class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
</div>

<!-- 阶段状态 -->
<div style="position: relative; left: 40px; top: -50px;" id="stageIcons">
    阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

    <%--方法一：不使用分界点point的写法--%>
    <%--<%--%>

    <%--//        Tran t = (Tran) request.getAttribute("t");--%>
    <%--//--%>
    <%--//        String currentStage = t.getStage();--%>
    <%--//--%>
    <%--//        String currentPossibility = pMap.get(currentStage);--%>

    <%--if ("0".equals(currentPossibility)) {--%>
    <%--//当前阶段为后2个阶段，前7个黑圈，后2个红叉黑叉--%>

    <%--//遍历所有阶段--%>
    <%--for (int i = 0; i < stageList.size(); i++) {--%>
    <%--String listStage = stageList.get(i).getValue();--%>
    <%--String listPossibility = pMap.get(listStage);--%>

    <%--if ("0".equals(listPossibility)) {--%>
    <%--//遍历的阶段为后2个阶段--%>
    <%--if (currentStage.equals(listStage)) {--%>
    <%--//遍历的阶段为当前阶段--%>
    <%--//红叉--%>
    <%--%>--%>
    <%--<span id="<%=i%>" class="glyphicon glyphicon-remove mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--data-content="<%=stageList.get(i).getText()%>" style="color: red;"--%>
    <%--onclick="changeStage('<%=listStage%>','<%=i%>')"></span>--%>
    <%---------------%>
    <%--<%--%>

    <%--} else {--%>
    <%--//遍历的阶段非当前阶段--%>
    <%--//黑叉--%>
    <%--%>--%>
    <%--<span id="<%=i%>" class="glyphicon glyphicon-remove mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--data-content="<%=stageList.get(i).getText()%>" style="color: black;"--%>
    <%--onclick="changeStage('<%=listStage%>','<%=i%>')"></span>--%>
    <%---------------%>
    <%--<%--%>
    <%--}--%>

    <%--} else {--%>
    <%--//遍历的阶段为前7个阶段--%>
    <%--//黑圈--%>
    <%--%>--%>
    <%--<span id="<%=i%>" class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--data-content="<%=stageList.get(i).getText()%>" style="color: black;"--%>
    <%--onclick="changeStage('<%=listStage%>','<%=i%>')"></span>--%>
    <%---------------%>
    <%--<%--%>
    <%--}--%>

    <%--}--%>


    <%--} else {--%>
    <%--//当前阶段为前7个阶段，前7个绿圈、绿色标记、黑圈，后2个黑叉--%>

    <%--//获取当前阶段的下标index--%>
    <%--//        int index = 0;--%>
    <%--//--%>
    <%--//        for (int i = 0; i < stageList.size(); i++) {--%>
    <%--//            String listStage = stageList.get(i).getValue();--%>
    <%--//--%>
    <%--//            if (currentStage.equals(listStage)) {--%>
    <%--//                index = i;--%>
    <%--//--%>
    <%--//                break;--%>
    <%--//            }--%>
    <%--//        }--%>

    <%--//遍历所有阶段--%>
    <%--for (int i = 0; i < stageList.size(); i++) {--%>
    <%--String listStage = stageList.get(i).getValue();--%>
    <%--String listPossibility = pMap.get(listStage);--%>

    <%--if ("0".equals(listPossibility)) {--%>
    <%--//后2个阶段--%>
    <%--//黑叉--%>
    <%--%>--%>
    <%--<span id="<%=i%>" class="glyphicon glyphicon-remove mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--data-content="<%=stageList.get(i).getText()%>" style="color: black;"--%>
    <%--onclick="changeStage('<%=listStage%>','<%=i%>')"></span>--%>
    <%---------------%>
    <%--<%--%>

    <%--} else {--%>
    <%--//前7个阶段--%>
    <%--if (i == index) {--%>
    <%--//当前阶段--%>
    <%--//绿色标记--%>
    <%--%>--%>
    <%--<span id="<%=i%>" class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--data-content="<%=stageList.get(i).getText()%>" style="color:  #90F790;"--%>
    <%--onclick="changeStage('<%=listStage%>','<%=i%>')"></span>--%>
    <%---------------%>
    <%--<%--%>

    <%--} else if (i < index) {--%>
    <%--//绿圈--%>
    <%--%>--%>
    <%--<span id="<%=i%>" class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--data-content="<%=stageList.get(i).getText()%>" style="color:  #90F790;"--%>
    <%--onclick="changeStage('<%=listStage%>','<%=i%>')"></span>--%>
    <%---------------%>
    <%--<%--%>

    <%--} else {--%>
    <%--//黑圈--%>
    <%--%>--%>
    <%--<span id="<%=i%>" class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--data-content="<%=stageList.get(i).getText()%>" style="color: black;"--%>
    <%--onclick="changeStage('<%=listStage%>','<%=i%>')"></span>--%>
    <%---------------%>
    <%--<%--%>
    <%--}--%>
    <%--}--%>

    <%--}--%>

    <%--}--%>
    <%--%>--%>


    <%--方法二：使用分界点point的写法--%>
    <%
        //        Tran t = (Tran) request.getAttribute("t");
        //
        //        String currentStage = t.getStage();
        //
        //        String currentPossibility = pMap.get(currentStage);
        //
        //        //获取当前阶段对应的下标index
        //        int index = 0;
        //
        //        for (int i = 0; i < stageList.size(); i++) {
        //            String listStage = stageList.get(i).getValue();
        //
        //            if (currentStage.equals(listStage)) {
        //                index = i;
        //
        //                break;
        //            }
        //        }

        if (index >= point) {
            //当前阶段为后2个阶段，前7个阶段为黑圈，后2个阶段为红叉黑叉
            for (int i = 0; i < point; i++) {
                String listStage = stageList.get(i).getValue();
                //前7个阶段
                //黑圈
    %>
    <span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
          class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom"
          data-content="<%=stageList.get(i).getText()%>" style="color: black;"></span>
    -----------
    <%

        }

        for (int i = point; i < stageList.size(); i++) {
            String listStage = stageList.get(i).getValue();
            //后2个阶段
            if (i == index) {
                //红叉
    %>
    <span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
          class="glyphicon glyphicon-remove mystage" data-toggle="popover" data-placement="bottom"
          data-content="<%=stageList.get(i).getText()%>" style="color: red;"></span>
    -----------
    <%

    } else {
        //黑叉
    %>
    <span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
          class="glyphicon glyphicon-remove mystage" data-toggle="popover" data-placement="bottom"
          data-content="<%=stageList.get(i).getText()%>" style="color: black;"></span>
    -----------
    <%
            }

        }

    } else {
        //当前阶段为前7个阶段，前7个阶段为绿圈、绿色标记、黑圈，后2个阶段为黑叉
        for (int i = 0; i < point; i++) {
            String listStage = stageList.get(i).getValue();
            if (i == index) {
                //绿色标记
    %>
    <span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
          class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom"
          data-content="<%=stageList.get(i).getText()%>" style="color: #90F790;"></span>
    -----------
    <%
    } else if (i < index) {
        //绿圈
    %>
    <span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
          class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom"
          data-content="<%=stageList.get(i).getText()%>" style="color: #90F790;"></span>
    -----------
    <%
    } else {
        //黑圈
    %>
    <span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
          class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom"
          data-content="<%=stageList.get(i).getText()%>" style="color: black;"></span>
    -----------
    <%
            }

        }

        for (int i = point; i < stageList.size(); i++) {
            String listStage = stageList.get(i).getValue();
            //黑叉
    %>
    <span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
          class="glyphicon glyphicon-remove mystage" data-toggle="popover" data-placement="bottom"
          data-content="<%=stageList.get(i).getText()%>" style="color: black;"></span>
    -----------
    <%
            }
        }

    %>


    <%--<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--data-content="资质审查" style="color: #90F790;"></span>--%>
    <%---------------%>
    <%--<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--data-content="需求分析" style="color: #90F790;"></span>--%>
    <%---------------%>
    <%--<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--data-content="价值建议" style="color: #90F790;"></span>--%>
    <%---------------%>
    <%--<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--data-content="确定决策者" style="color: #90F790;"></span>--%>
    <%---------------%>
    <%--<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--data-content="提案/报价" style="color: #90F790;"></span>--%>
    <%---------------%>
    <%--<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--data-content="谈判/复审"></span>--%>
    <%---------------%>
    <%--<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--data-content="成交"></span>--%>
    <%---------------%>
    <%--<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--data-content="丢失的线索"></span>--%>
    <%---------------%>
    <%--<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--data-content="因竞争丢失关闭"></span>--%>
    <%---------------%>

    <span class="closingDate">${t.expectedDate}</span>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: 0px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${t.money}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.customerId}-${t.name}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${t.expectedDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">客户名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.customerId}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="stage">${t.stage}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">类型</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.type}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="possibility">${t.possibility}</b>
        </div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">来源</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.source}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${t.activityId}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">联系人名称</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${t.contactsId}</b></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${t.createBy}&nbsp;&nbsp;</b>
            <small style="font-size: 10px; color: gray;">${t.createTime}</small>
        </div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="editBy">${t.editBy}</b><b>&nbsp;&nbsp;</b>
            <small style="font-size: 10px; color: gray;" id="editTime">${t.editTime}</small>
        </div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${t.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${t.contactSummary}&nbsp;
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${t.nextContactTime}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 100px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <!-- 备注1 -->
    <div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;">
            <h5>哎呦！</h5>
            <font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b>
            <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"
                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove"
                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>
            </div>
        </div>
    </div>

    <!-- 备注2 -->
    <div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;">
            <h5>呵呵！</h5>
            <font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b>
            <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"
                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove"
                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>
            </div>
        </div>
    </div>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 阶段历史 -->
<div>
    <div style="position: relative; top: 100px; left: 40px;">
        <div class="page-header">
            <h4>阶段历史</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>阶段</td>
                    <td>金额</td>
                    <td>可能性</td>
                    <td>预计成交日期</td>
                    <td>创建时间</td>
                    <td>创建人</td>
                </tr>
                </thead>
                <tbody id="historyBody">
                <%--<tr>--%>
                <%--<td>资质审查</td>--%>
                <%--<td>5,000</td>--%>
                <%--<td>10</td>--%>
                <%--<td>2017-02-07</td>--%>
                <%--<td>2016-10-10 10:10:10</td>--%>
                <%--<td>zhangsan</td>--%>
                <%--</tr>--%>
                <%--<tr>--%>
                <%--<td>需求分析</td>--%>
                <%--<td>5,000</td>--%>
                <%--<td>20</td>--%>
                <%--<td>2017-02-07</td>--%>
                <%--<td>2016-10-20 10:10:10</td>--%>
                <%--<td>zhangsan</td>--%>
                <%--</tr>--%>
                <%--<tr>--%>
                <%--<td>谈判/复审</td>--%>
                <%--<td>5,000</td>--%>
                <%--<td>90</td>--%>
                <%--<td>2017-02-07</td>--%>
                <%--<td>2017-02-09 10:10:10</td>--%>
                <%--<td>zhangsan</td>--%>
                <%--</tr>--%>
                </tbody>
            </table>
        </div>

    </div>
</div>

<div style="height: 200px;"></div>

</body>
</html>
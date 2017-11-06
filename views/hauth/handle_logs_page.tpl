<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">操作记录</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div id="hUserLogsTableTools" class="pull-right">
        &nbsp;
        {{if checkResIDAuth "2" "0101010300"}}
        <button onclick="LogsHandle.search()" class="btn btn-info btn-sm">
            <i class="icon-search"> 搜索</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0101010200"}}
        <button onclick="LogsHandle.download()" class="btn btn-info btn-sm" title="下载操作记录">
            <span class="icon-wrench"> 下载</span>
        </button>
        {{end}}
    </div>
</div>

<div class="subsystem-content">
    <div id="h-handle-logs">
        <table id="HandleLogsPageTable"
               class="table"
               data-toggle="table"
               data-unique-id="user_id"
               data-side-pagination="client"
               data-click-to-select="true"
               data-pagination="true"
               data-striped="true"
               data-show-refresh="false"
               data-page-size="60"
               data-page-list="[40,80,160,400,800,3000]"
               data-search="false">
            <thead>
            <tr>
                <th data-visible="false" data-field="uuid" data-sortable="true">账户</th>
                <th data-width="120px" data-field="user_id">用户</th>
                <th data-width="130px" data-align="center" data-field="handle_time">操作时间</th>
                <th data-width="80px" data-field="client_ip" data-sortable="true">客户端IP</th>
                <th data-width="60px" data-align="center" data-field="method">请求方式</th>
                <th data-field="url">路由</th>
                <th data-width="60px" data-align="center" data-field="status_code">状态</th>
                <th data-formatter="LogsHandle.formatter" data-field="data">请求数据</th>
            </tr>
            </thead>
        </table>
    </div>
</div>

<script type="text/javascript">
    var LogsHandle = {
        formatter:function(value,rows,index){
            return '<span ondblclick=LogsHandle.showHandleLogDetails(this) >'+value+'</span>'
        },
        download:function(){
            var x=new XMLHttpRequest();
            x.open("GET", "/v1/auth/handle/logs/download", true);
            x.responseType = 'blob';
            x.onload=function(e){
                download(x.response, "操作记录.xlsx", "application/vnd.ms-excel" );
            };
            x.send();
        },
        showHandleLogDetails:function(obj){

            var optHtml = '<div class="panel panel-default"><table class="table table-striped table-bordered table-condensed">'
            optHtml += "<tr><th class='col-sm-2 col-md-2 col-lg-2' valign='middle'>key</th><th valign='middle'>value</th></tr>"
            var row = JSON.parse($(obj).html());
            for (var x in row) {
                try {
                    var drow = JSON.parse(row[x]);
                    var dt = "";
                    for (var i = 0; i < drow.length; i++) {
                        if (i > 0) {
                            dt += "<hr/>";
                        }
                        for (var y in drow[i]) {
                            dt += y + " = " + drow[i][y] + "<br/>";
                        }
                    }
                    if (dt == "") {
                        dt = drow;
                    }
                    optHtml += "<tr style='vertical-align:middle !important;'><td valign='middle'>" + x + "</td><td>" + dt + "</td></tr>";
                } catch (e) {
                    optHtml += "<tr style='vertical-align:middle !important;'><td valign='middle'>" + x + "</td><td>" + row[x] + "</td></tr>";
                }
            }
            optHtml += "</table></div>";
            $.Hmodal({
                header: "客户端发送到服务器的参数信息",
                body: optHtml,
                height: "420px",
                submitBtn: false,
            })
        },
        search:function(){
            $.Hmodal({
                header:"高级搜索",
                body:$("#handle-logs-search").html(),
                width:"420px",
                callback:function (hmode) {
                    var userId = $("#h-logs-search-form").find("input[name='UserId']").val();
                    var startDate = $("#h-logs-search-form").find("input[name='StartDate']").val();
                    var endDate = $("#h-logs-search-form").find("input[name='EndDate']").val();

                    $("#HandleLogsPageTable").bootstrapTable('destroy');

                    $("#HandleLogsPageTable").bootstrapTable({
                        url:'/v1/auth/handle/logs/search',
                        uniqueId:'uuid',
                        striped: true,
                        pagination: true,
                        pageList:[40,80,160,400,800,3000],
                        showRefresh:false,
                        pageSize: 80,
                        search:false,
                        sidePagination: "server",
                        queryParams:function (params) {
                            params.UserId=userId;
                            params.StartDate=startDate;
                            params.EndDate=endDate;
                            return params;
                        }
                    });
                    $(hmode).remove();
                },
            })
        },
    };

    $(document).ready(function(){
        $("#HandleLogsPageTable").bootstrapTable({
            url:'/v1/auth/handle/logs',
            uniqueId:'uuid',
            striped: true,
            pagination: true,
            pageList:[40,80,160,400,800,3000],
            showRefresh:false,
            pageSize: 80,
            search:false,
            sidePagination: "server",
        });
    })
</script>
<script id="handle-logs-search" type="text/html">
    <form id="h-logs-search-form" class="row">
        <div class="form-group">
            <label class="col-sm-12" style="font-size: 14px; font-weight: 500;">账 号：</label>
            <div class="col-sm-12">
                <input style="height: 30px;line-height: 30px;" name="UserId"  type="text" class="form-control" placeholder="待查找的账号">
            </div>
        </div>
        <div class="form-group" style="margin-top: 23px;">
            <label class="col-sm-12" style="font-size: 14px;font-weight: 500;">开始时间：</label>
            <div class="col-sm-12">
                <input style="height: 30px;line-height: 30px;" onclick="laydate()" name="StartDate" class="form-control" placeholder="开始时间">
            </div>
        </div>
        <div class="form-group" style="margin-top: 23px;">
            <label class="col-sm-12" style="font-size: 14px;font-weight: 500;">结束时间：</label>
            <div class="col-sm-12">
                <input style="height: 30px;line-height: 30px;" onclick="laydate()" name="EndDate" class="form-control" placeholder="结束时间">
            </div>
        </div>
    </form>
</script>
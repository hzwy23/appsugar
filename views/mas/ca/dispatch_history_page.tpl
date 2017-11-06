<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">批次历史信息</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-left" style="height: 44px; line-height: 44px; width: 260px;">
        <span style="font-size: 10px; font-weight: 600; height: 30px; line-height: 30px; margin-top: 7px;display: inline" class="pull-left">&nbsp;&nbsp;所属域：</span>
        <select id="h-ca-dispatch-history-domain-list" class="form-control pull-left" style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
        </select>
    </div>
    <div class="pull-right">
        &nbsp;
        {{if checkResIDAuth "2" "0203020300"}}
        <button onclick="CaDispatchHistoryObj.download()" class="btn btn-info btn-sm" title="导出机构信息">
            <span class="icon-trash"> 下载</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0203020200"}}
        <button onclick="CaDispatchHistoryObj.delete()" class="btn btn-danger btn-sm" title="导出机构信息">
            <span class="icon-trash"> 删除</span>
        </button>
        {{end}}
    </div>
</div>

<div class="subsystem-content">
    <div id="h-ca-dispatch-history-content">
        <table id="h-ca-dispatch-history-table-details"
               data-toggle="table"
               data-striped="true"
               data-click-to-select="true"
               data-url="/v1/ca/dispatch/history/get"
               data-side-pagination="client"
               data-pagination="true"
               data-page-list="[20, 50, 100, 200]"
               data-search="false">
            <thead>
            <tr>
                <th data-field="state" data-checkbox="true"></th>
                <th data-sortable="true" data-align="center" data-field="dispatch_id" data-formatter="CaDispatchHistoryObj.formater">批次编码</th>
                <th data-sortable="true" data-field="dispatch_desc">批次名称</th>
                <th data-sortable="true" data-align="center" data-field="as_of_date">批次日期</th>
                <th data-sortable="true" data-align="center" data-field="dispatch_status_desc">批次状态</th>
                <th data-sortable="true" data-align="center" data-field="start_date">开始时间</th>
                <th data-sortable="true" data-align="center" data-field="end_date">结束时间</th>
                <th data-sortable="true" data-align="center" data-formatter="CaDispatchHistoryObj.calcCostTime">耗时</th>
                <th data-sortable="true" data-align="center" data-field="cnt_success" data-formatter="CaDispatchHistoryObj.getOKDetails">成功/条</th>
                <th data-sortable="true" data-align="center" data-field="cnt_error" data-formatter="CaDispatchHistoryObj.getErrDetails">失败/条</th>
                <th data-align="center" data-formatter="CaDispatchHistoryObj.getAmartDetails">分摊信息</th>
            </tr>
            </thead>
        </table>
    </div>
</div>

<script type="text/javascript">
    var CaDispatchHistoryObj = {
        download:function () {
            var domain_id = $("#h-ca-dispatch-history-domain-list").val();
            $.Hdownload({
                url:"/v1/ca/dispatch/history/download?domain_id="+domain_id,
                name:"批次历史信息",
            })
        },
        getOKDetails:function (value, row, index) {
            var html = "-";
            {{if checkResIDAuth "2" "0203020400"}}
                html = '<span class="h-td-btn btn-query btn-xs" style="color: #06d601;font-weight: 600;" onclick="CaDispatchHistoryObj.getDetails(\''+row.uuid+'\',\'Y\')">'+value+'</span>';
            {{end}}
            return html;
        },
        getAmartDetails:function (value, row, index) {
            var html = "-";
            {{if checkResIDAuth "2" "0203020500"}}
                html = '<span class="h-td-btn btn-success btn-xs" onclick="CaDispatchHistoryObj.getAmartInfo(\''+row.uuid+'\',\'Y\')">查询</span>';
            {{end}}
            return html;
        },
        getAmartInfo:function (sid) {
            Hutils.openTab({
                id:"ca#alloc#details",
                url:"/v1/ca/dispatch/alloc/page",
                data:{sid:sid},
                title:"详细分摊过程",
            })
        },
        getErrDetails:function (value, row, index) {
            var html = "-";
            {{if checkResIDAuth "2" "0203020400"}}
                html = '<span class="h-td-btn btn-query btn-xs" style="color: red; font-weight: 600;" onclick="CaDispatchHistoryObj.getDetails(\''+row.uuid+'\',\'N\')">'+value+'</span>';
            {{end}}
            return html;
        },
        formaterIndex:function (value, row, index) {
            return index+1
        },
        getDetails:function (uuid,flag) {
            var header = "成功分摊规则详细信息";
            if (flag == "N"){
                header = "失败的分摊规则详细信息";
            }
            $.Hmodal({
                header:header,
                body:$("#h-dispatch-history-details").html(),
                submitBtn:false,
                height:"500px",
                preprocess:function () {
                    $("#h-dispatch-history-details-table").bootstrapTable({
                        queryParams:function (params) {
                            params.uuid = uuid;
                            params.flag = flag;
                            return params
                        },
                        height:360,
                    })
                },
            })
        },
        delete:function () {
            var rows = $("#h-ca-dispatch-history-table-details").bootstrapTable('getSelections');
            if (rows.length==0) {
                $.Notify({
                    message:"您没有选择需要删除的批次历史记录",
                    type:"info",
                });
                return
            }
            $.Hconfirm({
                body:"点击确定,将会删除批次历史记录信息",
                callback:function () {
                    $.HAjaxRequest({
                        url:"/v1/ca/dispatch/history/delete",
                        type:"post",
                        data:{JSON:JSON.stringify(rows)},
                        success:function () {
                            $.Notify({
                                message:"删除批次历史记录信息成功",
                                type:"success",
                            });
                            $("#h-ca-dispatch-history-table-details").bootstrapTable('refresh')
                        }
                    })
                },
            })
        },
        formater:function (value,row,index) {
            var tmp = value.split("_join_")
            if (tmp.length == 2) {
                return tmp[1]
            } else {
                return tmp
            }
        },
        calcCostTime:function (value,row,index) {
            var start_date = new Date(row.start_date);
            var end_date = new Date(row.end_date);
            var s = (end_date.getTime() - start_date.getTime())/1000;
            var h = 0;
            var m = 0;
            if (s > 60) {
                m = (s/60).toFixed(0);
                s = (s%60).toFixed(0);
            }
            if (m > 60) {
                h = (m/60).toFixed(0);
                m = (m%60).toFixed(0);
            }
            var ret = "";
            if (h != 0) {
                ret = h+"时 "
            }
            if (m != 0) {
                ret += m+"分 "
            }
            if (s != 0) {
                ret += s+"秒"
            }
            return ret
        },
    };

    $(document).ready(function () {

        Hutils.InitDomain({
            id:"#h-ca-dispatch-history-domain-list",
            height:"24px",
            width:"180px",
            onclick:function () {
                $("#h-ca-dispatch-history-table-details").bootstrapTable('refresh');
            },
            callback:function () {
                $("#h-ca-dispatch-history-table-details").bootstrapTable({
                    queryParams:function (params) {
                        params.domain_id = $("#h-ca-dispatch-history-domain-list").val();
                        return params;
                    }
                })
            }
        });
    })
</script>

<script type="text/html" id="h-dispatch-history-details">
     <table id="h-dispatch-history-details-table"
               data-toggle="table"
               data-striped="true"
               data-url="/v1/ca/dispatch/history/details"
               data-side-pagination="client"
               data-pagination="true"
               data-page-list="[20, 50, 100, 200]"
               data-search="false">
            <thead>
            <tr>
                <th data-valign="middle" data-align="center" data-field="state" data-formatter="CaDispatchHistoryObj.formaterIndex">序号</th>
                <th	data-valign="middle" data-align="center" data-field="rule_id" data-formatter="CaDispatchHistoryObj.formater">分摊规则</th>
                <th data-field="message">消息</th>
            </tr>
            </thead>
        </table>
</script>
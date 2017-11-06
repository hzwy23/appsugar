<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">批次历史信息查询</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-left" style="height: 44px; line-height: 44px; width: 260px;">
        <span style="height: 30px; line-height: 30px; margin-top: 7px;display: inline" class="pull-left">&nbsp;&nbsp;所属域：</span>
        <select id="h-ftp-dispatch-history-info-domain-list" class="form-control pull-left" style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
        </select>
    </div>
    <div class="pull-right">
        <button onclick="" class="btn btn-info btn-sm" title="导出批次历史信息">
            <i class="icon-plus"> 导出</i>
        </button>
        <button onclick="FtpDispathcHistoryObj.delete()" class="btn btn-danger btn-sm" title="删除批次历史信息">
            <i class="icon-plus"> 删除</i>
        </button>
    </div>
</div>
<div id="h-ftp-dispatch-history-info-content" class="subsystem-content">
    <table id="h-ftp-dispatch-history-info-table-details"
           data-toggle="table"
           data-striped="true"
           data-url="/v1/ftp/dispatch/history/get"
           data-side-pagination="client"
           data-pagination="true"
           data-page-list="[20, 50, 100, 200]"
           data-search="false">
        <thead>
        <tr>
            <th data-field="state" data-checkbox="true"></th>
            <th data-formatter="FtpDispathcHistoryObj.formatterid" data-field="dispatch_id">批次编码</th>
            <th data-align="center" data-field="dispatch_date">批次日期</th>
            <th data-align="center" data-field="dispatch_status">批次状态</th>
            <th data-align="center" data-field="start_time">开始时间</th>
            <th data-align="center" data-field="end_time">结束时间</th>
            <th data-align="right" data-field="success_cnt">成功条数</th>
            <th data-align="right" data-field="error_cnt">错误条数</th>
            <th data-align="right" data-field="nobusiz_cnt">无定价单元</th>
            <th data-align="right" data-field="calc_cnt">计算条数</th>
            <th data-align="right" data-field="total_cnt">总共条数</th>
            <th data-align="right" data-field="offset_cnt">起始量</th>
            <th data-align="right" data-field="limit_cnt">偏移量</th>
            <!--<th data-align="center" data-formatter="FtpDispathcHistoryObj.formatter">日志查询</th>-->
        </tr>
        </thead>
    </table>
</div>
<script type="text/javascript">

    var FtpDispathcHistoryObj = {
        formatterid:function (value) {
            var tmp = value.split("_join_");
            if (tmp.length == 2){
                return tmp[1]
            } else {
                return value
            }
        },
        delete:function () {

            var rows = $("#h-ftp-dispatch-history-info-table-details").bootstrapTable('getSelections');
            if (rows.length == 0) {
                $.Notify({
                    title:"温馨提示:",
                    message:"您没有选择需要删除的批次历史信息.",
                    type:"info",
                });
                return
            }
            $.Hconfirm({
                body:"点击确定,将会删除批次历史信息",
                callback:function () {
                    $.HAjaxRequest({
                        url:"/v1/ftp/dispatch/history/post",
                        data:{JSON:JSON.stringify(rows)},
                        type:"post",
                        success:function () {
                            $.Notify({
                                title:"温馨提示:",
                                message:"删除批次历史信息成功",
                                type:"success",
                            });
                            $("#h-ftp-dispatch-history-info-table-details").bootstrapTable('refresh')
                        },
                    })
                }
            })
        },
        getCurveManagePage:function () {
            $.Notify({
                title:"温馨提示:",
                message:"正在维护中",
                type:"info",
            })
        },
        formatter:function (value, rows, index) {
            return '<span class="h-td-btn" onclick="FtpDispathcHistoryObj.getCurveManagePage(\''+rows.curve_id+'\',\''+ rows.curve_desc+'\')">查看历史</span>'
        },
    };

    $(document).ready(function () {
        $("#h-ftp-dispatch-history-info-content").height(document.documentElement.clientHeight-130)

        Hutils.InitDomain({
            id:"#h-ftp-dispatch-history-info-domain-list",
            height:"24px",
            width:"180px",
            onclick:function () {
                $("#h-ftp-dispatch-history-info-table-details").bootstrapTable('refresh');
            },
            callback:function (domainId) {
                $("#h-ftp-dispatch-history-info-table-details").bootstrapTable({
                    height:document.documentElement.clientHeight-130,
                    queryParams:function (params) {
                        params.domain_id = $("#h-ftp-dispatch-history-info-domain-list").val();
                        return params
                    }
                });
            },
        });
    })
</script>
<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">内生性调节项配置管理</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-left" style="height: 44px; line-height: 44px;">
        <span style="height: 30px; line-height: 30px; margin-top: 7px;display: inline" class="pull-left">所属域：</span>
        <select id="h-ftp-adjust-inner-define-info-domain-list" class="form-control pull-left" style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
        </select>
        <span style="font-size: 10px;font-weight: 600;" class="pull-left">&nbsp;&nbsp;调节项类型:</span>
        <select id="h-adjust-inner-type" class="form-control pull-left"
                style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px; padding: 0px;">
            <option value="601" selected>期限流动性溢价调节项</option>
            <option value="604">准备金调节项</option>
        </select>
        <button class="btn btn-default btn-xs" type="button"
                data-toggle="collapse" data-target="#h-ftp-adjust-inner-manage-collapse"
                aria-expanded="false" aria-controls="h-ftp-adjust-inner-manage-collapse"
                style="margin-left: 12px;">
            <i class="icon-double-angle-down"> 更多选项</i>
        </button>
        <div class="collapse pull-left" id="h-ftp-adjust-inner-manage-collapse"
             style="position: absolute; background-color: #fafafa; z-index: 20;">
            <span style="font-size: 10px;font-weight: 600;display: inline">&nbsp;&nbsp;生效日期:</span>
            <input onclick="laydate()" placeholder="调节项生效日期" id="h-adjust-inner-manage-start-date" class="form-control" style="width: 120px;height: 24px; line-height: 24px;display: inline;" />
            <span style="font-size: 10px;font-weight: 600;display: inline">&nbsp;&nbsp;失效日期:</span>
            <input onclick="laydate()" placeholder="调节项失效日期" id="h-adjust-inner-manage-end-date" class="form-control" style="width: 120px;height: 24px; line-height: 24px;display: inline;" />
            <button onclick="FtpCurveManageObj.search()" class="btn btn-default btn-xs" style="margin-left: 8px;"><i class="icon-search"> </i>查询</button>
        </div>
    </div>
    <div class="pull-right">
        <button onclick="" class="btn btn-info btn-sm" title="新增机构信息">
            <i class="icon-plus"> 新增</i>
        </button>
        <button onclick="" class="btn btn-info btn-sm" title="编辑机构信息">
            <span class="icon-edit"> 编辑</span>
        </button>
        <button onclick="" class="btn btn-danger btn-sm" title="删除机构信息">
            <span class="icon-trash"> 删除</span>
        </button>
    </div>
</div>
<div id="h-ftp-adjust-inner-info-content" class="subsystem-content">
    <table id="h-ftp-curve-define-info-table-details"
           data-toggle="table"
           data-url="/v1/ftp/adjust/inner/get"
           data-side-pagination="client"
           data-click-to-select="true"
           data-pagination="true"
           data-page-list="[20, 50, 100, 200]"
           data-search="false">
        <thead>
        <tr>
            <th data-field="state" data-checkbox="true"></th>
            <th data-field="busizId">业务单元编码</th>
            <th data-field="reservePercent">比例</th>
            <th data-field="reserveRate">利率</th>
            <th data-field="startDate">生效日期</th>
            <th data-field="endDate">失效日期</th>
            <th data-field="createDate">创建日期</th>
            <th data-field="createUser">创建人</th>
            <th data-field="modifyDate">修改日期</th>
            <th data-field="modifyUser">修改人</th>
        </tr>
        </thead>
    </table>
</div>
<script type="text/javascript">
    var FtpCurveDefineObj = {
        getCurveManagePage:function () {
            $.Notify({
                title:"温馨提示:",
                message:"正在维护中",
                type:"info",
            })
        },
        formatter:function (value, rows, index) {
            return '<span class="h-td-btn" onclick="FtpCurveDefineObj.getCurveManagePage(\''+rows.curve_id+'\',\''+ rows.curve_desc+'\')">曲线值管理</span>'
        }
    };

    $(document).ready(function () {
        $("#h-ftp-adjust-inner-info-content").height(document.documentElement.clientHeight-130)
        $("#h-adjust-inner-type").Hselect({
            height:"24px",
            value:"604"
        });

        Hutils.InitDomain({
            id:"#h-ftp-adjust-inner-define-info-domain-list",
            height:"24px",
            width:"180px",
            onclick:function () {

            },
            callback:function (domainId) {
                $("#h-ftp-curve-define-info-table-details").bootstrapTable({
                    queryParams:function (params) {
                        params.adjustInnerType = "604";
                        params.domainId = $("#h-ftp-adjust-inner-define-info-domain-list").val();
                        return params
                    }
                });
            }
        });
    })
</script>
<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">过滤器配置管理</span>
    </div>
</div>

<div class="row subsystem-toolbar">
    <div class="pull-left" style="height: 44px; line-height: 44px; width: 260px;">
        <span style="height: 30px; line-height: 30px; margin-top: 7px;display: inline" class="pull-left">&nbsp;&nbsp;所属域：</span>
        <select id="h-driver-info-domain-list" class="form-control pull-left" style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
        </select>
    </div>
    <div class="pull-right">
        <button onclick="" class="btn btn-info btn-sm">
            <i class="icon-plus"> 新增</i>
        </button>
        <button onclick="" class="btn btn-info btn-sm">
            <span class="icon-edit"> 编辑</span>
        </button>
        <button onclick="" class="btn btn-info btn-sm">
            <span class="icon-edit"> 导入</span>
        </button>
        <button onclick="" class="btn btn-info btn-sm">
            <span class="icon-trash"> 导出</span>
        </button>
        <button onclick="" class="btn btn-danger btn-sm">
            <span class="icon-trash"> 删除</span>
        </button>
    </div>
</div>
<div id="h-driver-info-content" class="subsystem-content">
    <table id="h-driver-info-table-details"
           data-toggle="table"
           data-url=""
           data-side-pagination="client"
           data-pagination="true"
           data-page-list="[20, 50, 100, 200]"
           data-search="false">
        <thead>
        <tr>
            <th data-field="state" data-checkbox="true"></th>
            <th data-field="code_number">过滤器编码</th>
            <th data-field="cost_direction_desc">过滤器名称</th>
            <th data-field="cost_direction_desc">概要</th>
            <th data-field="create_date">创建日期</th>
            <th data-field="create_user">创建人</th>
            <th data-field="modify_date">修改日期</th>
            <th data-field="modify_user">修改人</th>
            <th data-align="center">操作</th>
        </tr>
        </thead>
    </table>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        $("#h-driver-info-content").height(document.documentElement.clientHeight-130)

        Hutils.InitDomain({
            id:"#h-driver-info-domain-list",
            height:"24px",
            width:"180px",
            onclick:function () {

            },
            callback:function (domainId) {
                $("#h-driver-info-table-details").bootstrapTable({
                    height:document.documentElement.clientHeight-130,
                });
            },
        });
    })
</script>
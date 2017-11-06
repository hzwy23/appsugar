<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">详细分摊信息</span>
    </div>
</div>

<div class="row subsystem-toolbar">
    <div class="pull-left">
        <span id="h-ca-alloc-details-sid" style="display: none;">{{.Sid}}</span>
    </div>
</div>

<div class="subsystem-content" style="padding-top: 1px;">
    <div id="h-ca-alloc-details-content">
        <table id="h-ca-alloc-details-table"
               data-toggle="table"
               data-side-pagination="server"
               data-pagination="true"
               data-striped="true"
               data-page-size="30"
               data-url="/v1/ca/dispatch/alloc/details"
               data-page-list="[30, 50, 100, 200,600]"
               data-search="false">
            <thead>
            <tr>
                <th data-field="state" data-checkbox="true"></th>
                <th data-sortable="true" data-align="center" data-field="ruleId" data-formatter="CaAllocDetailsObj.formatter">分摊规则</th>
                <th data-sortable="true" data-align="center" data-field="orgUnitId" data-formatter="CaAllocDetailsObj.formatter">责任中心</th>
                <th data-sortable="true" data-align="center" data-field="costId" data-formatter="CaAllocDetailsObj.formatter">成本项</th>
                <th data-sortable="true" data-align="center" data-field="isoCurrencyCd" data-formatter="CaAllocDetailsObj.formatter">币种</th>
                <th data-sortable="true" data-align="right" data-field="monthAmount" data-formatter="CaAllocDetailsObj.formatter">接收费用</th>
                <th data-sortable="true" data-align="center" data-field="directionId" data-formatter="CaAllocDetailsObj.formatter">接收成本类别</th>
                <th data-sortable="true" data-align="center" data-field="ruleOutOrgId" data-formatter="CaAllocDetailsObj.formatter">摊出方</th>
                <th data-sortable="true" data-align="center" data-field="sourceOrgId" data-formatter="CaAllocDetailsObj.formatter">源机构</th>
                <th data-sortable="true" data-field="ruleAcceptRate">接收方占比</th>
                <th data-sortable="true" data-align="right" data-field="ruleAmount">规则处理金额</th>
            </tr>
            </thead>
        </table>
    </div>
</div>
<script>

    var CaAllocDetailsObj = {
        formatter:function(value){
            var tmp = value.split("_join_")
            if (tmp.length == 2){
                return tmp[1];
            } else {
                return tmp;
            }
        },
    };

    $(document).ready(function(){
        /*
         * 初始化table中信息
         * */
        var $table = $('#h-ca-alloc-details-table');
        $table.bootstrapTable({
            queryParams:function (params) {
                params.sid = $("#h-ca-alloc-details-sid").html();
                return params
            }
        });
    });
</script>
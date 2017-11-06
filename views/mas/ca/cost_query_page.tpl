<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">成本费用查询配置管理</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-left" style="height: 44px; line-height: 44px; display:inline;">
        <span style="font-size: 10px; font-weight: 600; height: 30px; line-height: 30px; margin-top: 7px;display: inline" class="pull-left">&nbsp;&nbsp;所属域：</span>
        <select id="h-ca-cost-manage-domain-list" class="form-control pull-left" style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
        </select>
        {{if checkResIDAuth "2" "0203040700"}}
        <span style="font-size: 10px; font-weight: 600; height: 30px; line-height: 30px; margin-top: 7px;display: inline" class="pull-left">&nbsp;&nbsp;数据日期：</span>
        <input id="h-ca-cost-manage-as-of-date" placeholder="数据日期过滤查询" onclick="laydate(this)" class="form-control pull-left" style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;" />
        <button onclick="CaCostQueryObj.search()" class="btn btn-default btn-xs pull-left" style="margin-left: 8px; margin-top: 11px;">查询</button>
        {{end}}
    </div>
    <div class="pull-right">
        &nbsp;
        {{if checkResIDAuth "2" "0203040200"}}
        <button onclick="CaCostQueryObj.add()" class="btn btn-info btn-sm" title="新增机构信息">
            <i class="icon-plus"> 新增</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0203040500"}}
        <button onclick="CaCostQueryObj.upload()" class="btn btn-info btn-sm" title="导入机构信息">
            <span class="icon-edit"> 导入</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0203040600"}}
        <button onclick="CaCostQueryObj.download()" class="btn btn-info btn-sm" title="导出机构信息">
            <span class="icon-trash"> 导出</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0203040300"}}
        <button onclick="CaCostQueryObj.edit()" class="btn btn-info btn-sm" title="编辑机构信息">
            <span class="icon-edit"> 编辑</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0203040400"}}
        <button onclick="CaCostQueryObj.delete()" class="btn btn-danger btn-sm" title="删除机构信息">
            <span class="icon-trash"> 删除</span>
        </button>
        {{end}}
    </div>
</div>
<div class="subsystem-content" style="padding-top: 3px;">
    <div id="h-ca-cost-manage-table-info">
        <table id="h-ca-cost-manage-info-table-details"
               data-toggle="table"
               data-striped="true"
               data-page-size="30"
               data-unique-id="uuid"
               data-click-to-select="true"
               data-url="/v1/ca/cost/manage/query"
               data-side-pagination="client"
               data-pagination="true"
               data-page-list="[20,,30, 50, 100, 200,1000]"
               data-search="false">
            <thead>
            <tr>
                <th data-field="state" data-checkbox="true"></th>
                <th data-sortable="true" data-align="center" data-field="as_of_date">数据日期</th>
                <th data-sortable="true" data-field="org_unit_id" data-formatter="CaCostQueryObj.formatter">责任中心编码</th>
                <th data-sortable="true" data-field="org_unit_desc">责任中心名称</th>
                <th data-sortable="true" data-align="center" data-field="iso_currency_desc">币种</th>
                <th data-sortable="true" data-field="cost_id" data-formatter="CaCostQueryObj.formatter">成本编码</th>
                <th data-sortable="true" data-field="cost_desc">成本名称</th>
                <th data-sortable="true" data-align="right" data-field="month_amount">本月发生额</th>
            </tr>
            </thead>
        </table>
    </div>
</div>
<script type="text/javascript">
    var CaCostQueryObj = {
        $table:$('#h-ca-cost-manage-info-table-details'),
        formatter:function (value, row, index) {
            var tmp = value.split("_join_")
            if (tmp.length == 2){
                return tmp[1]
            } else {
                return tmp
            }
        },
        search:function(){
        	var searchDate = $("#h-ca-cost-manage-as-of-date").val();
        	var domainId = $("#h-ca-cost-manage-domain-list").val();
        	$.HAjaxRequest({
        		url:"/v1/ca/cost/manage/search",
        		type:"POST",
        		data:{asOfDate:searchDate,domain_id:domainId},
        		success:function(data){
        			CaCostQueryObj.$table.bootstrapTable("load",data);
        		}
        	})
        },
        add:function(){
            $.Hmodal({
                body:$("#h-ca-cost-query-src").html(),
                width:"420px",
                header:"新增费用",
                callback:function(hmode){
                    $.HAjaxRequest({
                        url:"/v1/ca/cost/manage/post",
                        data:$("#h-ca-cost-query-form").serialize(),
                        type:"post",
                        success:function (data) {
                        	var as_of_date = $("#h-ca-cost-query-form").find("input[name='as_of_date']").val();
                        	$("#h-ca-cost-manage-as-of-date").val(as_of_date);
                            $(hmode).remove();
                            CaCostQueryObj.search();
                        },
                    })
                },
                preprocess:function(){
                    var domain_id = $("#h-ca-cost-manage-domain-list").val();

                    // 初始化成本池
                    $.getJSON("/v1/ca/cost/get",{domain_id:domain_id},function (data) {
                        var arr = new Array()
                        $(data).each(function (index, element) {
                            var e = {};
                            e.id = element.cost_id;
                            e.text = element.cost_desc;
                            e.upId = element.cost_up_id;
                            arr.push(e)
                        });
                        $("#h-ca-cost-query-form").find("select[name='cost_id']").Hselect({
                            height:"30px",
                            data:arr,
                        })
                    });
                    $.getJSON("/v1/common/isocurrency/get",{domain_id:domain_id},function (data) {
                        var arr = new Array()
                        $(data).each(function (index, element) {
                            var e = {};
                            e.id = element.iso_currency_cd;
                            e.text = element.iso_currency_desc;
                            e.upId = "##hzwy23##";
                            arr.push(e)
                        });
                        $("#h-ca-cost-query-form").find("select[name='iso_currency_cd']").Hselect({
                            height:"30px",
                            data:arr,
                        })
                    });

                    $.getJSON("/v1/ca/responsibility/get",{domain_id:domain_id},function(data) {
                        var arr = new Array()
                        $(data).each(function (index, element) {
                            var ijs = {}
                            ijs.id = element.org_unit_id;
                            ijs.text = element.org_unit_desc;
                            ijs.upId = element.org_up_id;
                            ijs.attr = element.org_attr_cd;
                            arr.push(ijs)
                        });

                        $("#h-ca-cost-query-form").find("select[name='org_unit_id']").Hselect({
                            data:arr,
                            height:"30px",
                            checkbox:false,
                            nodeSelect:false,
                        });
                    });

                    $("#h-ca-cost-query-form").find("input[name='domain_id']").val(domain_id)
                }
            })
        },
        edit:function(){
            var row = $("#h-ca-cost-manage-info-table-details").bootstrapTable('getSelections');
            if (row.length == 0) {
                $.Notify({
                    message:"您没有选择需要编辑的费用信息",
                    type:"info",
                })
                return
            } else if (row.length > 1) {
                $.Notify({
                    message:"您选择了多行信息,请选择一行进行编辑",
                    type:"info",
                })
                return
            }

            $.Hmodal({
                body:$("#h-ca-cost-query-src").html(),
                width:"420px",
                header:"编辑费用",
                callback:function(hmode){
                    $.HAjaxRequest({
                        url:"/v1/ca/cost/manage/put",
                        data:$("#h-ca-cost-query-form").serialize(),
                        type:"put",
                        success:function (data) {
                            $.Notify({
                                message:"修改费用信息成功",
                                type:"success",
                            });
                            var as_of_date = $("#h-ca-cost-query-form").find("input[name='as_of_date']").val();
                        	$("#h-ca-cost-manage-as-of-date").val(as_of_date);
                            $(hmode).remove();
                            CaCostQueryObj.search();
                        },
                    })
                },
                preprocess:function(){
                    var domain_id = $("#h-ca-cost-manage-domain-list").val();
                    // 初始化成本池
                    $.getJSON("/v1/ca/cost/get",{domain_id:domain_id},function (data) {
                        var arr = new Array()
                        $(data).each(function (index, element) {
                            var e = {};
                            e.id = element.cost_id;
                            e.text = element.cost_desc;
                            e.upId = element.cost_up_id;
                            arr.push(e)
                        });
                        $("#h-ca-cost-query-form").find("select[name='cost_id']").Hselect({
                            height:"30px",
                            data:arr,
                            value:row[0].cost_id,
                        })
                    });
                    $.getJSON("/v1/common/isocurrency/get",{domain_id:domain_id},function (data) {
                        var arr = new Array()
                        $(data).each(function (index, element) {
                            var e = {};
                            e.id = element.iso_currency_cd;
                            e.text = element.iso_currency_desc;
                            e.upId = "##hzwy23##";
                            arr.push(e)
                        });
                        $("#h-ca-cost-query-form").find("select[name='iso_currency_cd']").Hselect({
                            height:"30px",
                            data:arr,
                            value:row[0].iso_currency_cd,
                        })
                    });

                    $.getJSON("/v1/ca/responsibility/get",{domain_id:domain_id},function(data) {
                        var arr = new Array()
                        $(data).each(function (index, element) {
                            var ijs = {}
                            ijs.id = element.org_unit_id;
                            ijs.text = element.org_unit_desc;
                            ijs.upId = element.org_up_id;
                            ijs.attr = element.org_attr_cd;
                            arr.push(ijs)
                        });

                        $("#h-ca-cost-query-form").find("select[name='org_unit_id']").Hselect({
                            data:arr,
                            height:"30px",
                            checkbox:false,
                            nodeSelect:false,
                            value:row[0].org_unit_id,
                        });
                    });

                    $("#h-ca-cost-query-form").find("input[name='domain_id']").val(domain_id)
                    $("#h-ca-cost-query-form").find("input[name='month_amount']").val(row[0].month_amount)
                    $("#h-ca-cost-query-form").find("input[name='as_of_date']").val(row[0].as_of_date)
                    $("#h-ca-cost-query-form").find("input[name='uuid']").val(row[0].uuid)
                }
            })
        },
        delete:function(){
            var row = $("#h-ca-cost-manage-info-table-details").bootstrapTable('getSelections');
            if (row.length == 0) {
                $.Notify({
                    message:"您没有选择需要编辑的费用信息",
                    type:"info",
                })
                return
            }
            $.Hconfirm({
                body:"点击确定,删除费用信息",
                callback:function () {
                    $.HAjaxRequest({
                        url:"/v1/ca/cost/manage/delete",
                        type:"post",
                        data:{JSON:JSON.stringify(row)},
                        success:function () {
                            $.Notify({
                                message:"删除费用信息成功",
                                type:"success",
                            });
                            $(row).each(function (index, element) {
                                CaCostQueryObj.$table.bootstrapTable("removeByUniqueId",element.uuid)
                            })
                        },
                    })
                }
            })
        },
        download:function(){
            var domain_id = $("#h-ca-cost-manage-domain-list").val();
            $.Hdownload({
                url:"/v1/ca/cost/manage/download?domain_id="+domain_id,
                name:"费用详细信息",
            })
        },
        upload:function(){
            $.Hupload({
                url:"/v1/ca/cost/manage/upload",
                header:"费用上传",
                callback:function () {
                    CaCostQueryObj.$table.bootstrapTable("refresh");
                }
            })
        },
    };
    $(document).ready(function(){
        Hutils.InitDomain({
            id:"#h-ca-cost-manage-domain-list",
            height:"24px",
            width:"180px",
            onclick:function () {
                $("#h-ca-cost-manage-info-table-details").bootstrapTable('refresh');
            },
            callback:function () {
                $("#h-ca-cost-manage-info-table-details").bootstrapTable({
                    queryParams:function (params) {
                        params.domain_id = $("#h-ca-cost-manage-domain-list").val()
                        return params;
                    }
                });
            }
        });
    });
</script>

<script id="h-ca-cost-query-src" type="text/html">
    <form class="row" id="h-ca-cost-query-form">
        <div class="col-sm-12">
            <span>数据日期</span>
            <input name="as_of_date" placeholder="请选择数据日期" onclick="laydate(this)" class="form-control" style="height: 30px; line-height: 30px; width: 100%;">
        </div>
        <div class="col-sm-12" style="margin-top: 15px;">
            <span>责任中心</span>
            <select name="org_unit_id" class="form-control" style="height: 30px; line-height: 30px; width: 100%;">
            </select>
        </div>
        <div class="col-sm-12" style="margin-top: 15px;">
            <span>币种</span>
            <select name="iso_currency_cd" class="form-control" style="height: 30px; line-height: 30px; width: 100%;">
            </select>
        </div>
        <div class="col-sm-12" style="margin-top: 15px;">
            <span>成本池</span>
            <select name="cost_id" class="form-control" style="height: 30px; line-height: 30px; width: 100%;">
            </select>
        </div>
        <div class="col-sm-12" style="margin-top: 15px;">
            <span>期间发生额</span>
            <input name="month_amount" placeholder="请填写本月发生额,必须是数字" class="form-control" style="height: 30px; line-height: 30px; width: 100%;">
        </div>
        <input name="domain_id" style="display: none;">
        <input name="uuid" style="display: none;">
    </form>
</script>
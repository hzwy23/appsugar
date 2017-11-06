<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">批次中任务组关系配置管理</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-right">
		&nbsp;
		{{if checkResIDAuth "2" "0203010710"}}
        <button onclick="CaStaticRuleConfigObj.add()" class="btn btn-info btn-sm">
            <i class="icon-plus"> 新增</i>
        </button>
		{{end}}
		{{if checkResIDAuth "2" "0203010720"}}
        <button onclick="CaStaticRuleConfigObj.edit()" class="btn btn-info btn-sm">
            <i class="icon-edit"> 编辑</i>
        </button>
		{{end}}
		{{if checkResIDAuth "2" "0203010730"}}
        <button  onclick="CaStaticRuleConfigObj.delete()" class="btn btn-danger btn-sm">
            <i class="icon-trash"> 删除</i>
        </button>
		{{end}}
    </div>
</div>
<div class="subsystem-content" style="padding-top: 3px;">
	<div class="row">
		<div class="col-sm-12 col-md-5 col-md-3">
	        <div id="h-ca-amart-group-config-group-info" class="thumbnail">
	            <table class="table table-bordered table-condensed" style="margin-top: 8px;">
	                <tr style="height: 36px; line-height: 36px;"><td style="background-color: #fafafa;text-align: right;padding-right: 15px;vertical-align: middle;">批次编码</td>
	                    <td id="h-dispatch-config-id" style="vertical-align: middle;">{{.Code_number}}</td></tr>
	                <tr style="height: 36px; line-height: 36px;"><td  style="background-color: #fafafa;text-align: right;padding-right: 15px; vertical-align: middle;">批次名称</td>
	                    <td id="h-dispatch-config-id-name" style="vertical-align: middle;">{{.Dispatch_desc}}</td></tr>
	                <tr style="height: 36px; line-height: 36px;"><td  style="background-color: #fafafa;text-align: right;padding-right: 15px; vertical-align: middle;">批次状态</td>
	                    <td id="h-dispatch-config-id-status" style="vertical-align: middle;">{{.Dispatch_status_desc}}</td></tr>
	                <tr style="height: 36px; line-height: 36px;"><td style="background-color: #fafafa;text-align: right;padding-right: 15px; vertical-align: middle;">所属域</td>
	                    <td id="h-dispatch-config-id-domain-id" style="vertical-align: middle;">{{.Domain_id}}</td></tr>
	                <tr style="height: 36px; line-height: 36px;"><td style="background-color: #fafafa;text-align: right;padding-right: 15px; vertical-align: middle;">创建日期</td>
	                    <td id="h-dispatch-config-id-create-date" style="vertical-align: middle;">{{.Create_date}}</td></tr>
	                <tr style="height: 36px; line-height: 36px;"><td style="background-color: #fafafa;text-align: right;padding-right: 15px; vertical-align: middle;">创建人</td>
	                    <td id="h-dispatch-config-id-create-user" style="vertical-align: middle;">{{.Create_user}}</td></tr>
	                <tr style="height: 36px; line-height: 36px;"><td style="background-color: #fafafa;text-align: right;padding-right: 15px; vertical-align: middle;">修改日期</td>
	                    <td id="h-dispatch-config-id-modify-date" style="vertical-align: middle;">{{.Modify_date}}</td></tr>
	                <tr style="height: 36px; line-height: 36px;"><td style="background-color: #fafafa;text-align: right;padding-right: 15px; vertical-align: middle;">修改人</td>
	                    <td id="h-dispatch-config-id-modify-user" style="vertical-align: middle;">{{.Modify_user}}</td></tr>
	            </table>
	        </div>
	    </div>
	    <div id="h-ca-amart-dispatch-group-config-content" class="col-sm-12 col-md-7 col-lg-9" style="padding-left: 0px;">
	        <table id="h-ca-amart-dispatch-group-config-table"
	               data-toggle="table"
	               data-side-pagination="client"
	               data-pagination="true"
	               data-striped="true"
				   data-click-to-select="true"
	               data-unique-id="uuid"
	               data-page-size="20"
	               data-url="/v1/ca/dispatch/config/get"
	               data-page-list="[20, 50, 100, 200]"
	               data-search="false">
	            <thead>
	            <tr>
	                <th data-field="state" data-checkbox="true"></th>
	                <th data-sortable="true" data-align="center" data-field="group_id" data-formatter="CaStaticRuleConfigObj.formatter">规则组编码</th>
	                <th data-sortable="true" data-field="group_desc">规则组名称</th>
	                <th data-sortable="true" data-align="center" data-field="group_up_id" data-formatter="CaStaticRuleConfigObj.formatter">上级规则组编码</th>
	                <th data-sortable="true" data-align="center" data-field="group_up_desc">上级规则组名称</th>
	            </tr>
	            </thead>
	        </table>
	    </div>
	</div>
</div>
<script>
    var CaStaticRuleConfigObj = {
        add:function () {
            if ($("#h-dispatch-config-id-status").html() == "运行中"){
                $.Notify({
                    message:"运行中的任务,不允许新增任务组",
                    type:"danger",
                });
                return
            }
            $.Hmodal({
                header:"新增批次任务组",
                body:$("#h-ca-dispatch-group-config-src").html(),
                width:"420px",
                preprocess:function () {
                    var domain_id = $("#h-dispatch-config-id-domain-id").html();
                    var dispatch_id = $("#h-dispatch-config-id").html();

                    $("#h-ca-dispatch-group-config-form").find("input[name='domain_id']").val(domain_id)
                    $("#h-ca-dispatch-group-config-form").find("input[name='dispatch_id']").val(dispatch_id)

                    $.getJSON("/v1/ca/amart/group/get",{domain_id:domain_id},function (data) {
                        var arr = new Array()
                        $(data).each(function(index,element){
                            var ijs = {}
                            ijs.id=element.group_id;
                            ijs.text=element.group_desc;
                            ijs.upId="##hzwy23##";
                            arr.push(ijs)
                        });
                        $("#h-ca-dispatch-group-config-form").find("select[name='group_id']").Hselect({
                            height:"30px",
                            data:arr,
                        });

                        var ijs = {};
                        ijs.id="-1";
                        ijs.text="无";
                        ijs.upId="##hzwy23##";
                        arr.push(ijs);

                        $("#h-ca-dispatch-group-config-form").find("select[name='group_up_id']").Hselect({
                            height:"30px",
                            data:arr
                        });
                    });
                },
                callback:function (hmode) {
                    $.HAjaxRequest({
                        url:"/v1/ca/dispatch/config/post",
                        type:"post",
                        data:$("#h-ca-dispatch-group-config-form").serialize(),
                        success:function () {
                            $.Notify({
                                message:"设置批次分摊规则组成功",
                                type:"success",
                            });
                            $(hmode).remove();
                            $("#h-ca-amart-dispatch-group-config-table").bootstrapTable('refresh');
                        },
                    })
                }
            })
        },
        edit:function () {
            if ($("#h-dispatch-config-id-status").html() == "运行中"){
                $.Notify({
                    message:"运行中的任务,不允许编辑任务组",
                    type:"danger",
                })
                return
            }


            var sel = $('#h-ca-amart-dispatch-group-config-table').bootstrapTable('getSelections');
            if (sel.length == 0){
                $.Notify({
                    message:"请在下表中选择一项进行编辑",
                    type:"info",
                });
                return
            }else if (sel.length == 1){
                $.Hmodal({
                    header:"修改批次中分摊规则组信息",
                    body:$("#h-ca-dispatch-group-config-src").html(),
                    width:"420px",
                    preprocess:function(){
                        var domain_id = sel[0].domain_id;

                        $.getJSON("/v1/ca/amart/group/get",{domain_id:domain_id},function (data) {
                            var arr = new Array()
                            $(data).each(function(index,element){
                                var ijs = {}
                                ijs.id=element.group_id;
                                ijs.text=element.group_desc;
                                ijs.upId="##hzwy23##";
                                arr.push(ijs)
                            });
                            $("#h-ca-dispatch-group-config-form").find("select[name='group_id']").Hselect({
                                height:"30px",
                                data:arr,
                                value:sel[0].group_id,
                            });

                            var ijs = {}
                            ijs.id="-1";
                            ijs.text="无";
                            ijs.upId="##hzwy23##";
                            arr.push(ijs);

                            $("#h-ca-dispatch-group-config-form").find("select[name='group_up_id']").Hselect({
                                height:"30px",
                                data:arr,
                                value:sel[0].group_up_id,
                            });
                        });

                        $("#h-ca-dispatch-group-config-form").find("input[name='dispatch_id']").val(sel[0].dispatch_id);
                        $("#h-ca-dispatch-group-config-form").find("input[name='domain_id']").val(domain_id);
                        $("#h-ca-dispatch-group-config-form").find("input[name='uuid']").val(sel[0].uuid);
                    },
                    callback:function (hmode) {
                        $.HAjaxRequest({
                            url:"/v1/ca/dispatch/config/put",
                            type:"put",
                            data:$("#h-ca-dispatch-group-config-form").serialize(),
                            success:function () {
                                $.Notify({
                                    message:"更新任务优先级成功",
                                    type:"success",
                                });
                                $(hmode).remove();
                                $('#h-ca-amart-dispatch-group-config-table').bootstrapTable('refresh')
                            }
                        })
                    },
                })
            }else{
                $.Notify({
                    message:"你选择了多行信息，不知道想要编辑哪一行",
                    type:"info"
                })
                return
            }
        },
        delete:function () {
            var sel = $('#h-ca-amart-dispatch-group-config-table').bootstrapTable('getSelections');
            if (sel.length == 0) {
                $.Notify({
                    message:"您没有选择分摊规则",
                    type:"info",
                });
                return
            }

            if ($("#h-dispatch-config-id-status").html() == "运行中"){
                $.Notify({
                    message:"运行中的任务,不允许删除任务组",
                    type:"danger",
                })
                return
            }

            $.Hconfirm({
                body:"点击确定删除域共享",
                callback:function () {
                    $.HAjaxRequest({
                        url:"/v1/ca/dispatch/config/delete",
                        type:"post",
                        data:{JSON:JSON.stringify(sel)},
                        success:function () {
                            $.Notify({
                                message:"删除规则组中的分摊规则信息成功",
                                type:"success",
                            });
                            $(sel).each(function (index, element) {
                                $('#h-ca-amart-dispatch-group-config-table').bootstrapTable('removeByUniqueId',element.uuid)
                            })
                        },
                    })
                }
            })
        },
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
        var hwindow = document.documentElement.clientHeight;
        $("#h-ca-amart-group-config-group-info").height(hwindow-139)
        $("#h-ca-amart-dispatch-group-config-content").height(hwindow-130)

        /*
         * 初始化table中信息
         * */
        var $table = $('#h-ca-amart-dispatch-group-config-table');
        $table.bootstrapTable({
            height:hwindow-130,
            queryParams:function (params) {
                var dispatch_id = $("#h-dispatch-config-id-domain-id").html() + "_join_" + $("#h-dispatch-config-id").html();
                params.dispatch_id = dispatch_id;
                params.domain_id = $("#h-dispatch-config-id-domain-id").html();
                return params
            }
        });
    });
</script>

<script id="h-ca-dispatch-group-config-src" type="text/html">
    <form class="row" id="h-ca-dispatch-group-config-form">
        <div class="col-sm-12">
            <span>任务组:</span>
            <select name="group_id" class="form-control"></select>
        </div>
        <div class="col-sm-12" style="margin-top: 15px;">
            <span>上级任务组:</span>
            <select name="group_up_id" class="form-control"></select>
        </div>
        <input name="dispatch_id" style="display: none;"/>
        <input name="domain_id" style="display: none;" />
        <input name="uuid" style="display: none;" />
    </form>
</script>
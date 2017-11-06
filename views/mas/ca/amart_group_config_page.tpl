<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">规则组分摊规则配置管理</span>
    </div>
</div>

<div class="row subsystem-toolbar">
    <div class="pull-left">
        <div style="height: 44px; line-height: 44px;display: inline;">
            <span style="height: 30px; line-height: 30px; margin-top: 7px;display: inline"
                  class="pull-left">&nbsp;规则组编码 = <span id="h-domain-share-did">{{.Code_number}}</span></span>
            <span style="height: 30px; line-height: 30px; margin-top: 7px;display: inline"
                  class="pull-left">&nbsp;&nbsp;&nbsp;<i style="border: #0b4059 dotted 0.5px; height: 44px;"></i>&nbsp;&nbsp;&nbsp;规则组名称 = {{.Group_desc}}</span>
            <span style="height: 30px; line-height: 30px; margin-top: 7px;display: inline"
                  class="pull-left">&nbsp;&nbsp;&nbsp;<i style="border: #0b4059 dotted 0.5px;height: 44px;"></i>&nbsp;&nbsp;&nbsp;域编码 = <span id="h-domain-share-did-domain-id">{{.Domain_id}}</span></span>
        </div>
    </div>

    <div class="pull-right">
        &nbsp;
        {{if checkResIDAuth "2" "0202040520"}}
        <button onclick="CaStaticRuleConfigObj.add()" class="btn btn-info btn-sm">
            <i class="icon-plus"> 新增</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0202040530"}}
        <button onclick="CaStaticRuleConfigObj.edit()" class="btn btn-info btn-sm">
            <i class="icon-edit"> 编辑</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0202040540"}}
        <button  onclick="CaStaticRuleConfigObj.delete()" class="btn btn-danger btn-sm">
            <i class="icon-trash"> 删除</i>
        </button>
        {{end}}
    </div>
</div>

<div class="subsystem-content" style="padding-top: 3px;">
    <div id="h-ca-amart-group-rules-config-content">
        <table id="h-ca-amart-group-rules-config-table"
               data-toggle="table"
               data-side-pagination="client"
               data-pagination="true"
               data-striped="true"
               data-click-to-select="true"
               data-url="/v1/ca/amart/group/rules/get"
               data-page-list="[20, 50, 100, 200]"
               data-search="false">
            <thead>
            <tr>
                <th data-field="state" data-checkbox="true"></th>
                <th data-sortable="true" data-field="rule_id" data-formatter="CaStaticRuleConfigObj.formatter">分摊规则编码</th>
                <th data-sortable="true" data-field="rule_desc">分摊规则名称</th>
                <th data-sortable="true" data-align="center" data-field="priority">任务优先级</th>
                <th data-sortable="true" data-align="center" data-field="create_date">创建日期</th>
                <th data-sortable="true" data-align="center" data-field="create_user">创建人</th>
                <th data-sortable="true" data-align="center" data-field="modify_date">修改日期</th>
                <th data-sortable="true" data-align="center" data-field="modify_user">修改人</th>
            </tr>
            </thead>
        </table>
    </div>
</div>
<script>

    var CaStaticRuleConfigObj = {
        add:function () {
            $.Hmodal({
                header:"分摊规则配置",
                body:$("#h-ca-group-rules-config-src").html(),
                width:"420px",
                preprocess:function () {
                    var domain_id = $("#h-domain-share-did-domain-id").html();
                    var group_id = $("#h-domain-share-did").html();
                    $("#h-ca-group-rules-config-form").find("input[name='domain_id']").val(domain_id)
                    $("#h-ca-group-rules-config-form").find("input[name='group_id']").val(group_id)

                    $.getJSON("/v1/ca/responsibility/get",{domain_id:domain_id},function (data) {
                        var arr = new Array()
                        $(data).each(function(index,element){
                            var ijs = {}
                            ijs.id=element.org_unit_id;
                            ijs.text=element.org_unit_desc;
                            ijs.upId=element.org_up_id;
                            ijs.attr=element.org_attr_cd;
                            arr.push(ijs)
                        });
                        $("#h-ca-group-rules-config-form").find("select[name='org_unit_id']").Hselect({
                            height:"30px",
                            data:arr,
                            nodeSelect:false,
                            onclick:function () {
                                var domain_id = $("#h-domain-share-did-domain-id").html();
                                var org_unit_id = $("#h-ca-group-rules-config-form").find("select[name='org_unit_id']").val();
                                if (org_unit_id != undefined){
                                    $("#h-ca-group-rules-config-form").find("select[name='rule_id']").parent().show();
                                } else {
                                    $("#h-ca-group-rules-config-form").find("select[name='rule_id']").parent().hide();
                                }
                                $.getJSON("/v1/ca/amart/rules/get",{
                                    domain_id:domain_id,
                                    org_unit_id:org_unit_id,
                                },function (value) {
                                    var arr = new Array()
                                    $(value).each(function (index, element) {
                                        var e = {};
                                        e.id = element.rule_id;
                                        e.text = element.rule_desc;
                                        e.upId = "#hzwy23#";
                                        arr.push(e)
                                    });

                                    $("#h-ca-group-rules-config-form").find("select[name='rule_id']").Hselect({
                                        height:"30px",
                                        data:arr,
                                    });
                                })
                            }
                        });
                    });
                },
                callback:function (hmode) {
                    $.HAjaxRequest({
                        url:"/v1/ca/amart/group/rules/post",
                        type:"post",
                        data:$("#h-ca-group-rules-config-form").serialize(),
                        success:function () {
                            $.Notify({
                                message:"配置分摊规则成功",
                                type:"success",
                            });
                            $(hmode).remove();
                            $("#h-ca-amart-group-rules-config-table").bootstrapTable('refresh');
                        },
                    })
                }
            })
        },
        edit:function () {
            var sel = $('#h-ca-amart-group-rules-config-table').bootstrapTable('getSelections');
            if (sel.length == 0){
                $.Notify({
                    message:"请在下表中选择一项进行编辑",
                    type:"info",
                })
                return
            }else if (sel.length == 1){
                $.Hmodal({
                    header:"修改分摊规则组中的分摊规则",
                    body:$("#h-ca-group-rules-config-src").html(),
                    width:"420px",
                    preprocess:function(){
                        var domain_id = $("#h-domain-share-did-domain-id").html();
                        var priority = sel[0].priority;
                        var uuid = sel[0].uuid;
                        $("#h-ca-group-rules-config-form").find("select[name='org_unit_id']").parent().hide();
                        $("#h-ca-group-rules-config-form").find("select[name='rule_id']").parent().hide();
                        $("#h-ca-group-rules-config-form").find("input[name='priority']").val(priority);
                        $("#h-ca-group-rules-config-form").find("input[name='domain_id']").val(domain_id);
                        $("#h-ca-group-rules-config-form").find("input[name='group_id']").val(uuid);
                        $("#h-ca-group-rules-config-form").find("select[name='rule_id']").html("<option value='"+sel[0].rule_id+"' selected></option>");
                    },
                    callback:function (hmode) {
                        $.HAjaxRequest({
                            url:"/v1/ca/amart/group/rules/put",
                            type:"put",
                            data:$("#h-ca-group-rules-config-form").serialize(),
                            success:function () {
                                $.Notify({
                                    message:"更新任务优先级成功",
                                    type:"success",
                                });
                                $(hmode).remove();
                                $('#h-ca-amart-group-rules-config-table').bootstrapTable('refresh')
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
            var sel = $('#h-ca-amart-group-rules-config-table').bootstrapTable('getSelections');
            if (sel.length == 0) {
                $.Notify({
                    message:"您没有选择分摊规则",
                    type:"info",
                });
                return
            }

            $.Hconfirm({
                body:"点击确定移除任务组中的分摊规则",
                callback:function () {
                    $.HAjaxRequest({
                        url:"/v1/ca/amart/group/rules/delete",
                        type:"post",
                        data:{JSON:JSON.stringify(sel)},
                        success:function () {
                            $.Notify({
                                message:"删除规则组中的分摊规则信息成功",
                                type:"success",
                            });
                            $('#h-ca-amart-group-rules-config-table').bootstrapTable('refresh')
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
        /*
         * 初始化table中信息
         * */
        var $table = $('#h-ca-amart-group-rules-config-table');
        $table.bootstrapTable({
            queryParams:function (params) {
                var group_id = $("#h-domain-share-did-domain-id").html() + "_join_" + $("#h-domain-share-did").html();
                params.group_id = group_id;
                params.domain_id = $("#h-domain-share-did-domain-id").html();
                return params
            }
        });
    });
</script>

<script id="h-ca-group-rules-config-src" type="text/html">
    <form class="row" id="h-ca-group-rules-config-form">
        <div class="col-sm-12">
            <span>费用摊出方:</span>
            <select name="org_unit_id" class="form-control"></select>
        </div>
        <div class="col-sm-12" style="margin-top: 15px;display: none;">
            <span>分摊规则:</span>
            <select name="rule_id" class="form-control"></select>
        </div>
        <div class="col-sm-12" style="margin-top: 15px;">
            <span>任务优先级:</span>
            <input placeholder="任务优先级,数字越大,优先级越高,范围[1-1024]" type="number" name="priority" class="form-control" style="height: 30px; line-height: 30px;"/>
        </div>
        <input name="group_id" style="display: none;"/>
        <input name="domain_id" style="display: none;" />
    </form>
</script>
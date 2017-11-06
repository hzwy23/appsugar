<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">静态分摊规则配置管理</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-right">
        &nbsp;
        {{if checkResIDAuth "2" "0202030200"}}
        <button onclick="CaStaticRuleConfigObj.add()" class="btn btn btn-info btn-sm">
            <i class="icon-plus"> 新增</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0202030300"}}
        <button onclick="CaStaticRuleConfigObj.edit()" class="btn btn btn-info btn-sm">
            <i class="icon-edit"> 编辑</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0202030400"}}
        <button  onclick="CaStaticRuleConfigObj.delete()" class="btn btn btn-danger btn-sm">
            <i class="icon-trash"> 删除</i>
        </button>
        {{end}}
    </div>
</div>

<div class="row" style="padding-top: 3px;">
    <div class="col-sm-12 col-md-5 col-md-3">
        <div id="h-ca-static-define-details" class="thumbnail">
            <table class="table table-bordered table-condensed" style="margin-top: 8px;">
                <tr style="height: 36px; line-height: 36px;"><td style="background-color: #fafafa;text-align: right;padding-right: 15px;vertical-align: middle;">静态分摊规则编码</td>
                    <td id="h-ca-static-define" style="background-color:#FFFFFF;vertical-align: middle;">{{.Code_number}}</td></tr>
                <tr style="height: 36px; line-height: 36px;"><td  style="background-color: #fafafa;text-align: right;padding-right: 15px; vertical-align: middle;">静态分摊规则名称</td>
                    <td id="h-ca-static-define-name" style="background-color:#FFFFFF;vertical-align: middle;">{{.Static_amart_desc}}</td></tr>
                <tr style="height: 36px; line-height: 36px;"><td style="background-color: #fafafa;text-align: right;padding-right: 15px; vertical-align: middle;">所属域</td>
                    <td id="h-ca-static-define-domain-id" style="background-color:#FFFFFF;vertical-align: middle;">{{.Domain_id}}</td></tr>
                <tr style="height: 36px; line-height: 36px;"><td style="background-color: #fafafa;text-align: right;padding-right: 15px; vertical-align: middle;">创建日期</td>
                    <td id="h-ca-static-define-create-date" style="background-color:#FFFFFF;vertical-align: middle;">{{.Create_date}}</td></tr>
                <tr style="height: 36px; line-height: 36px;"><td style="background-color: #fafafa;text-align: right;padding-right: 15px; vertical-align: middle;">创建人</td>
                    <td id="h-ca-static-define-create-user" style="background-color:#FFFFFF;vertical-align: middle;">{{.Create_user}}</td></tr>
                <tr style="height: 36px; line-height: 36px;"><td style="background-color: #fafafa;text-align: right;padding-right: 15px; vertical-align: middle;">修改日期</td>
                    <td id="h-ca-static-define-modify-date" style="background-color:#FFFFFF;vertical-align: middle;">{{.Modify_date}}</td></tr>
                <tr style="height: 36px; line-height: 36px;"><td style="background-color: #fafafa;text-align: right;padding-right: 15px; vertical-align: middle;">修改人</td>
                    <td id="h-ca-static-define-modify-user" style="background-color:#FFFFFF;vertical-align: middle;">{{.Modify_user}}</td></tr>
            </table>
        </div>
    </div>
    <div id="h-ca-static-config-details" class="col-sm-12 col-md-7 col-lg-9" style="padding-left: 0px;">
        <table id="h-ca-static-config-table"
               data-toggle="table"
               data-side-pagination="client"
               data-pagination="true"
               data-striped="true"
               data-click-to-select="true"
               data-url="/v1/ca/static/config/get"
               data-page-list="[20, 50, 100, 200]"
               data-search="false">
            <thead>
            <tr>
                <th data-field="state" data-checkbox="true"></th>
                <th data-sortable="true" data-align="center" data-field="amart_accept_id" data-formatter="CaStaticRuleConfigObj.formatterorgid">费用接收方编码</th>
                <th data-sortable="true" data-field="amart_accept_desc">费用接收方名称</th>
                <th data-sortable="true" data-align="center" data-field="radio">比例(%)</th>
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
        formatter:function (val, row, index) {
            if (val == 0) {
                return "机构级"
            } else if (val == 1){
                return "账户级"
            } else {
                return "<span style='color: red;'>未知</span>"
            }
        },
        formatterorgid:function (val, row, index) {
            var tmp = val.split("_join_");
            if (tmp.length == 2) {
                return tmp[1]
            } else {
                return tmp
            }
        },
        add:function () {
            $.Hmodal({
                header:"静态分摊比例规则配置",
                body:$("#h-ca-static-rules-config-src").html(),
                width:"420px",
                preprocess:function () {
                    //获取列表中被授权访问的域信息
                    var domain_id = $("#h-ca-static-define-domain-id").html();
                    var static_amart_id = $("#h-ca-static-define").html()
                    $("#h-ca-static-rules-config-form").find("input[name='domain_id']").val(domain_id);
                    $("#h-ca-static-rules-config-form").find("input[name='static_amart_id']").val(static_amart_id);

                    $.getJSON("/v1/ca/responsibility/get",{domain_id:domain_id},function(data){
                        var arr = new Array()
                        $(data).each(function(index,element){
                            var ijs = {}
                            ijs.id=element.org_unit_id;
                            ijs.text=element.org_unit_desc;
                            ijs.upId=element.org_up_id;
                            arr.push(ijs)
                        });
                        $("#h-ca-static-rules-config-form").find("select[name='amart_accept_id']").Hselect({
                            data:arr,
                            height:"30px",
                            nodeSelect:false,
                        })
                    });
                },
                callback:function (hmode) {
                    $.HAjaxRequest({
                        url:"/v1/ca/static/config/post",
                        type:"post",
                        data:$("#h-ca-static-rules-config-form").serialize(),
                        success:function () {
                            $(hmode).remove()
                            $.Notify({
                                message:"新增静态分摊规则信息成功",
                                type:"success",
                            });
                            $('#h-ca-static-config-table').bootstrapTable('refresh')
                        },
                    })
                }
            })
        },
        edit:function () {
            var sel = $('#h-ca-static-config-table').bootstrapTable('getSelections');
            if (sel.length == 0){
                $.Notify({
                    message:"请在列表中选择一项静态分摊信息进行编辑",
                    type:"warning",
                });
                return
            }else if (sel.length == 1){
                $.Hmodal({
                    header:"编辑静态分摊比例配置信息",
                    body:$("#h-ca-static-rules-config-src").html(),
                    width:"420px",
                    preprocess:function(){
                        //获取列表中被授权访问的域信息
                        var domain_id = $("#h-ca-static-define-domain-id").html();
                        var static_amart_id = $("#h-ca-static-define").html()
                        $("#h-ca-static-rules-config-form").find("input[name='domain_id']").val(domain_id);
                        $("#h-ca-static-rules-config-form").find("input[name='static_amart_id']").val(static_amart_id);
                        $("#h-ca-static-rules-config-form").find("input[name='radio']").val(sel[0].radio);
                        $("#h-ca-static-rules-config-form").find("input[name='uuid']").val(sel[0].uuid);

                        $.getJSON("/v1/ca/responsibility/get",{domain_id:domain_id},function(data){
                            var arr = new Array()
                            $(data).each(function(index,element){
                                var ijs = {};
                                ijs.id=element.org_unit_id;
                                ijs.text=element.org_unit_desc;
                                ijs.upId=element.org_up_id;
                                arr.push(ijs)
                            });

                            var ijs = {};
                            ijs.id="mas_join_-1";
                            ijs.text="责任中心树根节点";
                            ijs.upId="######hzwy23#####";
                            arr.push(ijs);

                            $("#h-ca-static-rules-config-form").find("select[name='amart_accept_id']").Hselect({
                                data:arr,
                                height:"30px",
                                nodeSelect:false,
                                value:sel[0].amart_accept_id,
                            })
                        });
                    },
                    callback:function (hmode) {
                        $.HAjaxRequest({
                            url:"/v1/ca/static/config/put",
                            type:"put",
                            data:$("#h-ca-static-rules-config-form").serialize(),
                            success:function () {
                                $(hmode).remove()
                                $.Notify({
                                    message:"修改静态分摊规则信息成功",
                                    type:"success",
                                });
                                $('#h-ca-static-config-table').bootstrapTable('refresh')
                            },
                        });
                    },
                })
            }else{
                $.Notify({
                    message:"只能选择<span style='font-weight: 600;color: red;'>一项</span>进行编辑",
                    type:"warning"
                });
                return
            }
        },
        delete:function () {
            var sel = $('#h-ca-static-config-table').bootstrapTable('getSelections');
            if (sel.length == 0) {
                $.Notify({
                    message:"请选择需要删除的静态分摊规则",
                    type:"warning",
                })
                return
            }

            $.Hconfirm({
                body:"点击确定删除静态规则",
                callback:function () {
                    $.HAjaxRequest({
                        url:"/v1/ca/static/config/delete",
                        type:"post",
                        data:{JSON:JSON.stringify(sel),domain_id:$("#h-ca-static-define-domain-id").html()},
                        success:function () {
                            $.Notify({
                                message:"删除信息成功",
                                type:"success",
                            });
                            $('#h-ca-static-config-table').bootstrapTable('refresh')
                        },
                    })
                }
            })
        },
    };

    $(document).ready(function(){
        var hwindow = document.documentElement.clientHeight;
        $("#h-ca-static-define-details").height(hwindow-159)
        $("#h-ca-static-config-details").height(hwindow-150)

        /*
         * 初始化table中信息
         * */
        var $table = $('#h-ca-static-config-table');
        $table.bootstrapTable({
            height:hwindow-130,
            queryParams:function (params) {
                params.id = $("#h-ca-static-define").html(),
                params.domain_id = $("#h-ca-static-define-domain-id").html()
                return params
            }
        });
    });
</script>

<script id="h-ca-static-rules-config-src" type="text/html">
    <form class="row" id="h-ca-static-rules-config-form">
        <div class="col-sm-12">
            <label class="h-label" style="width: 100%;">费用接收方：</label>
            <select name="amart_accept_id" class="form-control" style="height:30px; line-height: 30px;">
            </select>
        </div>
        <div class="col-sm-12" style="margin-top: 15px;">
            <label class="h-label" style="width: 100%;">接收比例：</label>
            <input placeholder="如接收百分之十,请填写 10" name="radio" type="number" class="form-control" style="height: 30px; line-height: 30px;"/>
        </div>
        <input name="static_amart_id" style="display: none;"/>
        <input name="domain_id" style="display: none;"/>
        <input name="uuid" style="display: none;"/>
    </form>
</script>
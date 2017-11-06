<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">分摊规则配置管理</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-left" style="height: 44px; line-height: 44px; display: inline;">
        <span style="font-size: 10px; font-weight: 600; height: 30px; line-height: 30px; margin-top: 7px;display: inline" class="pull-left">&nbsp;&nbsp;所属域：</span>
        <select id="h-ca-amart-rules-domain-list" class="form-control pull-left"
                style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
        </select>
        <span style="font-size: 10px;font-weight: 600;height: 30px; line-height: 30px;margin-top: 7px;display: inline" class="pull-left">&nbsp;&nbsp;责任中心:</span>
        <select id="h-ca-rules-org-tree-info-list" class="form-control pull-left"
                style="width: 180px;height: 24px; line-height: 24px;margin-top: 10px;padding: 0px;">
        </select>
    </div>
    <div class="pull-right">
        &nbsp;
        {{if checkResIDAuth "2" "0202020200"}}
        <button onclick="CaAmartRulesObj.add()" class="btn btn-info btn-sm" title="新增机构信息">
            <i class="icon-plus"> 新增</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0202020500"}}
        <button onclick="CaAmartRulesObj.upload()" class="btn btn-info btn-sm" title="导入机构信息">
            <span class="icon-edit"> 导入</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0202020600"}}
        <button onclick="CaAmartRulesObj.download()" class="btn btn-info btn-sm" title="导出机构信息">
            <span class="icon-trash"> 导出</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0202020300"}}
        <button onclick="CaAmartRulesObj.edit()" class="btn btn-info btn-sm" title="编辑机构信息">
            <span class="icon-edit"> 编辑</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0202020400"}}
        <button onclick="CaAmartRulesObj.delete()" class="btn btn-danger btn-sm" title="删除机构信息">
            <span class="icon-trash"> 删除</span>
        </button>
        {{end}}
    </div>
</div>
<div class="subsystem-content" style="padding-top: 3px;">
    <div id="h-ca-amart-rules-table-info">
        <table id="h-ca-amart-rules-info-table-details"
               data-toggle="table"
               data-striped="true"
               data-click-to-select="true"
               data-url="/v1/ca/amart/rules/get"
               data-side-pagination="client"
               data-pagination="true"
               data-page-size="30"
               data-page-list="[10,20,30, 50, 100, 200]"
               data-search="false">
            <thead>
            <tr>
                <th data-valign="middle" data-field="state" data-checkbox="true"></th>
                <th data-sortable="true" data-valign="middle" data-field="code_number">分摊规则编码</th>
                <th data-sortable="true" data-valign="middle" data-field="rule_desc">规则名称</th>
                <th data-sortable="true" data-valign="middle" data-field="org_unit_desc">摊出方名称</th>
                <th data-sortable="true" data-valign="middle" data-field="cost_desc">成本池</th>
                <th data-sortable="true" data-valign="middle" data-field="direction_desc">成本类别</th>
                <th data-sortable="true" data-valign="middle" data-align="center" data-field="amart_type" data-formatter="CaAmartRulesObj.formattertype">分摊级别</th>
                <th data-sortable="true" data-valign="middle" data-field="accept_direction_desc">接收方成本类别</th>
                <th data-valign="middle" data-align="center" data-field="accept_org_unit_id" data-formatter="CaAmartRulesObj.formatterAcceptOrgId">费用接收方</th>
                <th data-valign="middle" data-align="center" data-field="amart_mode" data-formatter="CaAmartRulesObj.formattermode">分摊方式</th>
            </tr>
            </thead>
        </table>
    </div>
</div>

<script type="text/javascript">

    var CaAmartRulesObj = {
        $table:$('#h-ca-amart-rules-info-table-details'),
        upload:function () {
            $.Hupload({
                header:"导入分摊规则信息",
                url:"/v1/ca/amart/rules/upload",
                callback:function () {
                    var domain_id = $("#h-ca-amart-rules-domain-list").val();
                    CaAmartRulesObj.tree(domain_id);
                },
            })
        },
        download:function () {
            var domain_id = $("#h-ca-amart-rules-domain-list").val();
            $.Hdownload({
                url:"/v1/ca/amart/rules/download?domain_id="+domain_id,
                name:"分摊规则配置信息",
            });
        },
        deleteCurnetDriver:function (obj) {
            $(obj).parent().prev().remove();
            $(obj).parent().remove();
        },
        updateCost:function (rule_id,domain_id) {
            $.getJSON("/v1/ca/amart/rules/cost/get",{domain_id:domain_id,rule_id:rule_id},function (data) {
                if (data.length > 0) {
                    $("#h-ca-amart-rule-form").find("input[name='cost_proportion_rate']").val(data[0].cost_proportion_rate);
                    $("#h-ca-amart-rule-form").find("select[name='cost_proportion_id']").val(data[0].cost_proportion_id).trigger("change");
                }
            })
        },
        updateDriver:function (rule_id) {
            var domain_id = $("#h-ca-amart-rules-domain-list").val();

            $.getJSON("/v1/ca/amart/rules/driver/get",{domain_id:domain_id,rule_id:rule_id},function (xdata) {
                if (xdata.length == 0) {
                    // 处理动因选项
                    $.getJSON("/v1/ca/driver/get",{domain_id:domain_id},function (data) {
                        var arr = new Array();
                        $(data).each(function (index, element) {
                            var e = {};
                            e.id = element.driver_id;
                            e.text = element.driver_desc;
                            e.upId = "##hzwy23##";
                            arr.push(e)
                        });

                        $("#h-ca-amart-rule-form").find("select[name='driver_id']").Hselect({
                            height:"30px",
                            data:arr,
                        });
                    });
                    return
                }

                $(xdata).each(function (index, pelement) {
                    if (index == 0) {
                        // 处理动因选项
                        var domain_id = $("#h-ca-amart-rules-domain-list").val();
                        $.getJSON("/v1/ca/driver/get",{domain_id:domain_id},function (data) {
                            var arr = new Array();
                            $(data).each(function (index, element) {
                                var e = {};
                                e.id = element.driver_id;
                                e.text = element.driver_desc;
                                e.upId = "##hzwy23##";
                                arr.push(e)
                            });
                            $("#h-ca-amart-rule-form").find("select[name='driver_id']").Hselect({
                                height:"30px",
                                data:arr,
                                value:pelement.driver_id,
                            });
                        });

                        $("#h-ca-amart-rule-form").find("input[name='radio']").val(pelement.rate)

                    } else {
                        var rad = (Math.random() * 100000).toFixed(0);
                        var select_name = "driver_id_join_"+rad;
                        var input_name = "radio_join_" +rad;
                        var exist = $("#h-ca-amart-rule-form").find("select[name='"+select_name+"']").length

                        while (exist > 0) {
                            rad = (Math.random() * 100000).toFixed(0);
                            select_name = "driver_id_join_"+rad;
                            input_name = "radio_join_" +rad;
                            exist = $("#h-ca-amart-rule-form").find("select[name='"+select_name+"']").length;
                        }

                        var opt = '<div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px;border-bottom: #cccccc solid 1px;padding-bottom: 8px;">' +
                            '<label class="h-label" style="width: 100%;">动因编码：</label>' +
                            '<select name="'+select_name+'" style="width: 100%;height: 30px;line-height: 30px;">'+
                            '</select>'+
                            '</div>'+
                            '<div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px;border-bottom: #cccccc solid 1px;padding-bottom: 8px;">'+
                            '<label class="h-label" style="width: 100%;">分摊费用比例(%)：</label>'+
                            '<input placeholder="请输入处理费用比例，必须是小于或等于100的数字（必填）" type="text" class="form-control" name="'+input_name+'" style="width: 90%;height: 30px;line-height: 30px;display: inline;" value="' + pelement.rate + '">'+
                            '<button type="button" onclick="CaAmartRulesObj.deleteCurnetDriver(this)" class="btn btn-xs btn-danger pull-right" style="height: 30px; line-height: 30px; width: 10%;" title="删除动因"><i class="icon-trash"></i></button>'+
                            '</div>';
                        // 处理动因选项
                        $("#h-ca-amart-rules-add-driver").parent().before(opt);

                        var domain_id = $("#h-ca-amart-rules-domain-list").val();

                        $.getJSON("/v1/ca/driver/get",{domain_id:domain_id},function (data) {
                            var arr = new Array();
                            $(data).each(function (index, element) {
                                var e = {};
                                e.id = element.driver_id;
                                e.text = element.driver_desc;
                                e.upId = "##hzwy23##";
                                arr.push(e)
                            });

                            $("#h-ca-amart-rule-form").find("select[name='"+select_name+"']")
                                .Hselect({
                                    height:"30px",
                                    data:arr,
                                    value:pelement.driver_id
                                });
                        });
                    }
                })

            });
        },
        updateAcceptOrg:function (rule_id,domain_id) {
            $.getJSON("/v1/ca/amart/rules/org/accept",{domain_id:domain_id,rule_id:rule_id},function (data) {
                var list = $("#h-ca-amart-rule-form").find("select[name='accept_org_unit_id']").next().find("ul");
                $(list).find("li").each(function (index, element) {
                    $(data).each(function (i, e) {
                        if ($(element).attr("data-id")==e.accept_org_unit_id  && $(element).attr("data-attr") == "0") {
                            $(element).find("input").prop("checked",true)
                        }
                    })
                });
            })
        },
        addDriver:function (obj) {
            var rad = (Math.random() * 100000).toFixed(0);
            var select_name = "driver_id_join_"+rad;
            var input_name = "radio_join_" +rad;
            var exist = $("#h-ca-amart-rule-form").find("select[name='"+select_name+"']").length

            while (exist > 0) {
                rad = (Math.random() * 100000).toFixed(0);
                select_name = "driver_id_join_"+rad;
                input_name = "radio_join_" +rad;
                exist = $("#h-ca-amart-rule-form").find("select[name='"+select_name+"']").length;
            }

            var opt = '<div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px;border-bottom: #cccccc solid 1px;padding-bottom: 8px;">' +
                '<label class="h-label" style="width: 100%;">动因编码：</label>' +
                '<select name="'+select_name+'" style="width: 100%;height: 30px;line-height: 30px;">'+
                '</select>'+
                '</div>'+
                '<div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px;border-bottom: #cccccc solid 1px;padding-bottom: 8px;">'+
                '<label class="h-label" style="width: 100%;">分摊费用比例(%)：</label>'+
                '<input placeholder="请输入处理费用比例，必须是小于或等于100的数字（必填）" type="text" class="form-control" name="'+input_name+'" style="width: 90%;height: 30px;line-height: 30px;display: inline;">'+
                '<button type="button" onclick="CaAmartRulesObj.deleteCurnetDriver(this)" class="btn btn-xs btn-danger pull-right" style="height: 30px; line-height: 30px; width: 10%;" title="删除动因"><i class="icon-trash"></i></button>'+
                '</div>';
            // 处理动因选项
            $(obj).parent().before(opt);

            var domain_id = $("#h-ca-amart-rules-domain-list").val();

            $.getJSON("/v1/ca/driver/get",{
                domain_id:domain_id,
            },function (data) {
                var arr = new Array();
                $(data).each(function (index, element) {
                    var e = {};
                    e.id = element.driver_id;
                    e.text = element.driver_desc;
                    e.upId = "##hzwy23##";
                    arr.push(e)
                });

                $("#h-ca-amart-rule-form").find("select[name='"+select_name+"']")
                    .Hselect({
                        height:"30px",
                        data:arr,
                    });
            });
        },
        add:function(){

            $.Hworkflow({
                body:$("#h-ca-amart-rules-input-form").html(),
                header:"新增分摊规则信息",
                callback:function(hmode){
                    var acceptOrgList = new Array();
                    var list = $("#h-ca-amart-rule-form").find("select[name='accept_org_unit_id']").next().find("ul");
                    $(list).find("li").each(function (index, element) {
                        if ($(element).find("input").is(":checked") && $(element).attr("data-attr") == "0") {
                            acceptOrgList.push($(element).attr("data-id"))
                        }
                    });
                    $("#h-ca-amart-rule-form").find("input[name='accept_org_list']").val(acceptOrgList)

                    $.HAjaxRequest({
                        url:"/v1/ca/amart/rules/post",
                        data:$("#h-ca-amart-rule-form").serialize(),
                        type:"post",
                        success:function (data) {
                            $.Notify({
                                message:"新增分摊规则成功",
                                type:"success",
                            });
                            $(hmode).remove();
                            var domain_id = $("#h-ca-amart-rules-domain-list").val();
                            var id = $("#h-ca-rules-org-tree-info-list").val();
                            // 根据责任中心编码,查询这个责任中心下所有的责任中心信息
                            $.getJSON("/v1/ca/amart/rules/get",{domain_id:domain_id,org_unit_id:id},function (data) {
                                CaAmartRulesObj.$table.bootstrapTable('load',data)
                            });
                        },
                    })
                },
                preprocess:function(){
                    var domain_id = $("#h-ca-amart-rules-domain-list").val();
                    var $form = $("#h-ca-amart-rule-form");
                    $form.find("input[name='domain_id']").val(domain_id);

                    $.getJSON("/v1/ca/static/radio/get",{domain_id:domain_id},function (data) {
                        var arr =  new Array();
                        $(data).each(function (index, element) {
                            var e = {};
                            e.id = element.static_amart_id;
                            e.text = element.static_amart_desc;
                            e.upId = "##hzwy23##";
                            arr.push(e)
                        });

                        $form.find("select[name='static_amart_id']").Hselect({
                            height:"30px",
                            data:arr,
                        })
                    });

                    $form.find("select[name='amart_mode']").Hselect({
                        height:"30px",
                        value:"0",
                        onclick:function (obj) {
                            var amart_mode = $form.find("select[name='amart_mode']").val();
                            if (amart_mode == undefined){
                                $.Notify({
                                    message:"分摊方式无效",
                                    type:"warning",
                                });
                                return
                            }
                            if (amart_mode == "1") {
                                $form.find("select[name='accept_org_unit_id']").parent().hide();
                                $form.find("select[name='static_amart_id']").parent().show();
                                $form.find("select[name='cost_proportion_id']").parent().hide();
                                $form.find("input[name='cost_proportion_rate']").parent().hide();
                                var dobj = $form.find("select[name='driver_id']").parent().hide();
                                $(dobj).nextAll().each(function (index,element) {
                                    $(element).hide();
                                })
                            } else if (amart_mode == "0") {
                                $form.find("select[name='accept_org_unit_id']").parent().show();
                                $form.find("select[name='static_amart_id']").parent().hide();
                                $form.find("select[name='cost_proportion_id']").parent().hide();
                                $form.find("input[name='cost_proportion_rate']").parent().hide();
                                var dobj = $form.find("select[name='driver_id']").parent().show();
                                $(dobj).nextAll().each(function (index,element) {
                                    $(element).show();
                                })
                            } else {
                                $form.find("select[name='accept_org_unit_id']").parent().show();
                                $form.find("select[name='static_amart_id']").parent().hide();
                                $form.find("select[name='cost_proportion_id']").parent().show();
                                $form.find("input[name='cost_proportion_rate']").parent().show();
                                var dobj = $form.find("select[name='driver_id']").parent().hide();
                                $(dobj).nextAll().each(function (index,element) {
                                    $(element).hide();
                                })
                            }
                        }
                    });
                    $form.find("select[name='amart_type']").Hselect({
                        height:"30px",
                        value:"0",
                    });

                    // 初始化费用摊出方与费用接收方
                    $.getJSON("/v1/ca/responsibility/get",{domain_id:domain_id},function(data){
                        var arr = new Array()
                        var select_id = $("#h-ca-rules-org-tree-info-list").val()

                        $(data).each(function(index,element){
                            var ijs = {}
                            ijs.id=element.org_unit_id;
                            ijs.text=element.org_unit_desc;
                            ijs.upId=element.org_up_id;
                            ijs.attr=element.org_attr_cd;
                            arr.push(ijs)
                            if (ijs.id == select_id && ijs.attr == "1") {
                                select_id = ""
                            }
                        });

                        $form.find("select[name='org_unit_id']").Hselect({
                            data:arr,
                            height:"30px",
                            checkbox:false,
                            nodeSelect:false,
                            value:select_id,
                        });

                        $form.find("select[name='accept_org_unit_id']").Hselect({
                            data:arr,
                            height:"30px",
                            checkbox:true,
                            nodeSelect:false,
                            dashed:true,
                        });
                    });

                    // 初始化费用摊出方域接收方方向
                    $.getJSON("/v1/ca/cost/direction/get",{domain_id:domain_id},function (data) {
                        var arr = new Array()
                        $(data).each(function (index, element) {
                            var e = {}
                            e.id = element.direction_id;
                            e.text = element.direction_desc;
                            e.upId = element.direction_up_id;
                            arr.push(e)
                        });
                        $form.find("select[name='direction_id']").Hselect({
                            height:"30px",
                            data:arr,
                        });
                        $form.find("select[name='accept_direction_id']").Hselect({
                            height:"30px",
                            data:arr,
                        });
                        $form.find("select[name='cost_proportion_id']").Hselect({
                            height:"30px",
                            data:arr,
                        })
                    });

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
                        $form.find("select[name='cost_id']").Hselect({
                            height:"30px",
                            data:arr,
                        })
                    });

                    // 处理动因选项
                    $.getJSON("/v1/ca/driver/get",{domain_id:domain_id},function (data) {
                        var arr = new Array();
                        $(data).each(function (index, element) {
                            var e = {};
                            e.id = element.driver_id;
                            e.text = element.driver_desc;
                            e.upId = "##hzwy23##";
                            arr.push(e)
                        });

                        $form.find("select[name='driver_id']").Hselect({
                            height:"30px",
                            data:arr,
                        });
                    });
                }
            })
        },
        edit:function(){
            var rows = CaAmartRulesObj.$table.bootstrapTable("getSelections");
            if (rows.length == 0){
                $.Notify({
                    message:"请在列表中选择需要编辑的分摊规则",
                    type:"info",
                });
                return
            } else if (rows.length == 1){
                var row = rows[0];
                var domain_id = row.domain_id;

                $.Hworkflow({
                    body:$("#h-ca-amart-rules-input-form").html(),
                    header:"修改分摊规则信息",
                    preprocess:function () {
                        var domain_id = $("#h-ca-amart-rules-domain-list").val();
                        var $form = $("#h-ca-amart-rule-form");
                        $form.find("input[name='domain_id']").val(domain_id);
                        $form.find("input[name='rule_id']").val(row.code_number).attr("readonly","readonly");
                        $form.find("input[name='rule_desc']").val(row.rule_desc);

                        $.getJSON("/v1/ca/static/radio/get",{domain_id:domain_id},function (data) {
                            var arr =  new Array();
                            $(data).each(function (index, element) {
                                var e = {};
                                e.id = element.static_amart_id;
                                e.text = element.static_amart_desc;
                                e.upId = "##hzwy23##";
                                arr.push(e)
                            });

                            $form.find("select[name='static_amart_id']").Hselect({
                                height:"30px",
                                data:arr,
                                value:row.static_amart_id,
                            })
                        });

                        $form.find("select[name='amart_mode']").Hselect({
                            height:"30px",
                            value:row.amart_mode,
                            onclick:function (obj) {
                                var amart_mode = $form.find("select[name='amart_mode']").val();
                                if (amart_mode == undefined){
                                    $.Notify({
                                        message:"分摊方式无效",
                                        type:"warning",
                                    });
                                    return
                                }
                                if (amart_mode == "1") {
                                    $form.find("select[name='accept_org_unit_id']").parent().hide();
                                    $form.find("select[name='static_amart_id']").parent().show();
                                    $form.find("select[name='cost_proportion_id']").parent().hide();
                                    $form.find("input[name='cost_proportion_rate']").parent().hide();
                                    var dobj = $form.find("select[name='driver_id']").parent().hide();
                                    $(dobj).nextAll().each(function (index,element) {
                                        $(element).hide();
                                    })
                                } else if (amart_mode == "0") {
                                    $form.find("select[name='accept_org_unit_id']").parent().show();
                                    $form.find("select[name='static_amart_id']").parent().hide();
                                    $form.find("select[name='cost_proportion_id']").parent().hide();
                                    $form.find("input[name='cost_proportion_rate']").parent().hide();
                                    var dobj = $form.find("select[name='driver_id']").parent().show();
                                    $(dobj).nextAll().each(function (index,element) {
                                        $(element).show();
                                    })
                                } else {
                                    $form.find("select[name='accept_org_unit_id']").parent().show();
                                    $form.find("select[name='static_amart_id']").parent().hide();
                                    $form.find("select[name='cost_proportion_id']").parent().show();
                                    $form.find("input[name='cost_proportion_rate']").parent().show();
                                    var dobj = $form.find("select[name='driver_id']").parent().hide();
                                    $(dobj).nextAll().each(function (index,element) {
                                        $(element).hide();
                                    })
                                }
                            }
                        });

                        var amart_mode = $form.find("select[name='amart_mode']").val();
                        if (amart_mode == undefined){
                            $.Notify({
                                message:"分摊方式无效",
                                type:"warning",
                            });
                            return
                        }
                        if (amart_mode == "1") {
                            $form.find("select[name='accept_org_unit_id']").parent().hide();
                            $form.find("select[name='static_amart_id']").parent().show();
                            $form.find("select[name='cost_proportion_id']").parent().hide();
                            $form.find("input[name='cost_proportion_rate']").parent().hide();
                            var dobj = $form.find("select[name='driver_id']").parent().hide();
                            $(dobj).nextAll().each(function (index,element) {
                                $(element).hide();
                            })
                        } else if (amart_mode == "0") {
                            $form.find("select[name='accept_org_unit_id']").parent().show();
                            $form.find("select[name='static_amart_id']").parent().hide();
                            $form.find("select[name='cost_proportion_id']").parent().hide();
                            $form.find("input[name='cost_proportion_rate']").parent().hide();
                            var dobj = $form.find("select[name='driver_id']").parent().show();
                            $(dobj).nextAll().each(function (index,element) {
                                $(element).show();
                            })
                        } else {
                            $form.find("select[name='accept_org_unit_id']").parent().show();
                            $form.find("select[name='static_amart_id']").parent().hide();
                            $form.find("select[name='cost_proportion_id']").parent().show();
                            $form.find("input[name='cost_proportion_rate']").parent().show();
                            var dobj = $form.find("select[name='driver_id']").parent().hide();
                            $(dobj).nextAll().each(function (index,element) {
                                $(element).hide();
                            })
                        }

                        $form.find("select[name='amart_type']").Hselect({
                            height:"30px",
                            value:row.amart_type,
                        });

                        // 初始化费用摊出方与费用接收方
                        $.getJSON("/v1/ca/responsibility/get",{domain_id:domain_id},function(data){
                            var arr = new Array();
                            $(data).each(function(index,element){
                                var ijs = {}
                                ijs.id=element.org_unit_id;
                                ijs.text=element.org_unit_desc;
                                ijs.upId=element.org_up_id;
                                ijs.attr=element.org_attr_cd;
                                arr.push(ijs)
                            });

                            $form.find("select[name='org_unit_id']").Hselect({
                                data:arr,
                                height:"30px",
                                checkbox:false,
                                nodeSelect:false,
                                value:row.org_unit_id,
                            });

                            $.getJSON("/v1/ca/amart/rules/org/accept",{domain_id:row.domain_id,rule_id:row.rule_id},function (data) {
                                var selected = new Array();
                                $(data).each(function (i, e) {
                                    selected.push(e.accept_org_unit_id);
                                });

                                $form.find("select[name='accept_org_unit_id']").Hselect({
                                    data:arr,
                                    height:"30px",
                                    checkbox:true,
                                    nodeSelect:false,
                                    dashed:true,
                                    value:selected,
                                });
                            });
                        });

                        // 初始化费用摊出方和接收方方向
                        $.getJSON("/v1/ca/cost/direction/get",{domain_id:domain_id},function (data) {
                            var arr = new Array()
                            $(data).each(function (index, element) {
                                var e = {}
                                e.id = element.direction_id;
                                e.text = element.direction_desc;
                                e.upId = element.direction_up_id;
                                arr.push(e)
                            });

                            $form.find("select[name='direction_id']").Hselect({
                                height:"30px",
                                data:arr,
                                value:row.direction_id,
                            });
                            $form.find("select[name='accept_direction_id']").Hselect({
                                height:"30px",
                                data:arr,
                                value:row.accept_direction_id,
                            });

                            $form.find("select[name='cost_proportion_id']").Hselect({
                                height:"30px",
                                data:arr,
                            })
                        });

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
                            $form.find("select[name='cost_id']").Hselect({
                                height:"30px",
                                data:arr,
                                value:row.cost_id,
                            })
                        });

                        CaAmartRulesObj.updateDriver(row.rule_id);
                        CaAmartRulesObj.updateCost(row.rule_id,row.domain_id);
                    },
                    callback:function(hmode){
                        var acceptOrgList = new Array();
                        var list = $("#h-ca-amart-rule-form").find("select[name='accept_org_unit_id']").next().find("ul");
                        $(list).find("li").each(function (index, element) {
                            if ($(element).find("input").is(":checked") && $(element).attr("data-attr") == "0") {
                                acceptOrgList.push($(element).attr("data-id"))
                            }
                        });
                        $("#h-ca-amart-rule-form").find("input[name='accept_org_list']").val(acceptOrgList)


                        $.HAjaxRequest({
                            url:"/v1/ca/amart/rules/put",
                            data:$("#h-ca-amart-rule-form").serialize(),
                            type:"put",
                            success:function (data) {
                                $.Notify({
                                    message:"新增分摊规则成功",
                                    type:"success",
                                });
                                $(hmode).remove();
                                var domain_id = $("#h-ca-amart-rules-domain-list").val()
                                var id = $("#h-ca-rules-org-tree-info-list").val();
                                // 根据责任中心编码,查询这个责任中心下所有的责任中心信息
                                $.getJSON("/v1/ca/amart/rules/get",{domain_id:domain_id,org_unit_id:id},function (data) {
                                    CaAmartRulesObj.$table.bootstrapTable('load',data)
                                });
                            },
                        })
                    }
                })
            } else {
                $.Notify({
                    message:"只能选择<span style='font-weight: 600;color: red;'>一项</span>进行编辑",
                    type:"warning",
                });
                return
            }
        },
        delete:function(){
            var data = CaAmartRulesObj.$table.bootstrapTable("getSelections");
            // 将数组中的值复制一份
            if (data.length == 0){
                $.Notify({
                    message:"请在下表中选择需要删除的分摊规则",
                    type:"info",
                });
                return
            } else {
                $.Hconfirm({
                    callback:function () {
                        $.HAjaxRequest({
                            url:"/v1/ca/amart/rules/delete",
                            type:"post",
                            data:{JSON:JSON.stringify(data)},
                            success:function () {
                                $.Notify({
                                    message:"删除分摊规则信息成功",
                                    type:"success",
                                });
                                var domain_id = data[0].domain_id;
                                var id = $("#h-ca-rules-org-tree-info-list").val();
                                // 根据责任中心编码,查询这个责任中心下所有的责任中心信息
                                $.getJSON("/v1/ca/amart/rules/get",{domain_id:domain_id,org_unit_id:id},function (data) {
                                    CaAmartRulesObj.$table.bootstrapTable('load',data)
                                });
                            },
                        })
                    },
                    body:"点击确定,删除分摊规则信息<br/>删除后无法恢复"
                })
            }
        },
        tree:function(domain_id){
            $.getJSON("/v1/ca/responsibility/get",{domain_id:domain_id},function(data){
                if (data.length==0){
                    $.Notify({
                        message:"您选择的域中没有机构信息",
                        type:"info",
                    });
                    CaAmartRulesObj.$table.bootstrapTable('load',[])
                    $("#h-ca-rules-org-tree-info-list").Hselect({
                        data:[],
                        height:"24px",
                        width:"320px",
                    })
                } else {
                    var arr = new Array()
                    $(data).each(function(index,element){
                        var ijs = {}
                        ijs.id = element.org_unit_id
                        ijs.text = element.org_unit_desc
                        ijs.upId = element.org_up_id
                        arr.push(ijs)
                    });
                    $("#h-ca-rules-org-tree-info-list").Hselect({
                        data:arr,
                        height:"24px",
                        width:"320px",
                        placeholder:"<i style='color: #959595;font-size: 12px;'>--选择过滤责任中心--</i>",
                        onclick:function(){
                            var id = $("#h-ca-rules-org-tree-info-list").val();
                            var domain_id = $("#h-ca-amart-rules-domain-list").val()
                            // 根据责任中心编码,查询这个责任中心下所有的责任中心信息
                            $.getJSON("/v1/ca/amart/rules/get",{domain_id:domain_id,org_unit_id:id},function (data) {
                                CaAmartRulesObj.$table.bootstrapTable('load',data)
                            })
                        }
                    });
                    var domain_id = $("#h-ca-amart-rules-domain-list").val();
                    // 根据责任中心编码,查询这个责任中心下所有的责任中心信息
                    $.getJSON("/v1/ca/amart/rules/get",{domain_id:domain_id},function (data) {
                        CaAmartRulesObj.$table.bootstrapTable('load',data)
                    })
                }
            })
        },
        formatterAcceptOrgId:function (value,rows,index) {
            if (value == "") {
                return ''
            } else {
                var html = "-"
                {{if checkResIDAuth "2" "0202020700"}}
                    html = '<span class="h-td-btn btn-warning btn-xs" onclick="CaAmartRulesObj.getAcceptOrgInfo(\''+rows.rule_id+'\')">查询</span>';
                {{end}}
                return html;
            }
        },
        formattermode:function (value,rows,index) {
            var html = "-";
            if (value == "0") {
                {{if checkResIDAuth "2" "0202020800"}}
                    html = '<span class="h-td-btn btn-success btn-xs" onclick="CaAmartRulesObj.getDirverInfo(\''+rows.rule_id+'\')">动因比例</span>';
                {{end}}
                return html;
            } else if (value == "1") {
                {{if checkResIDAuth "2" "0202030100"}}
                    html = '<span class="h-td-btn btn-primary btn-xs" onclick="CaAmartRulesObj.getStaticRadioInfo(\''+rows.static_amart_id+'\')">静态比例</span>';
                {{end}}
                return html;
            } else if (value == "2") {
                {{if checkResIDAuth "2" "0202020900"}}
                    html = '<span class="h-td-btn btn-info btn-xs" onclick="CaAmartRulesObj.getCostProportionInfo(\''+rows.rule_id+'\')">费用占比</span>';
                {{end}}
                return html;
            } else {
                return "<span style='color: red;'>未知方式</span>"
            }
        },
        getDirverInfo:function (id) {
            var domain_id = $("#h-ca-amart-rules-domain-list").val();
            $.Hmodal({
                header:"动因信息",
                height:"400px",
                width:"720px",
                body:$("#h-ca-amart-rules-driver-info-src").html(),
                footerBtnStatus:false,
                preprocess:function(){
                    $("#h-ca-amart-rules-driver-info-table-details").bootstrapTable({
                        height:300,
                        queryParams:function(params){
                            params.domain_id = domain_id;
                            params.rule_id = id;
                            return params
                        },
                    })
                },
            })
        },
        getCostProportionInfo:function (rule_id) {
            var domain_id = $("#h-ca-amart-rules-domain-list").val();
            $.Hmodal({
                header:"费用占比比例信息",
                height:"400px",
                width:"720px",
                body:$("#h-ca-amart-rules-cost-info-src").html(),
                footerBtnStatus:false,
                preprocess:function(){
                    $("#h-ca-amart-rules-cost-info-table-details").bootstrapTable({
                        height:300,
                        queryParams:function(params){
                            params.domain_id = domain_id;
                            params.rule_id = rule_id;
                            return params
                        },
                    })
                },
            })
        },
        getStaticRadioInfo:function (id) {
            var domain_id = $("#h-ca-amart-rules-domain-list").val();
            var tmp = id.split("_join_")
            if (tmp.length == 2) {
                id = tmp[1]
            }

            $.Hmodal({
                header:"静态分摊比例信息",
                height:"400px",
                width:"720px",
                body:$("#h-ca-amart-rules-static-info-src").html(),
                footerBtnStatus:false,
                preprocess:function(){
                    $("#h-ca-amart-rules-static-info-table-details").bootstrapTable({
                        height:300,
                        queryParams:function(params){
                            params.domain_id = domain_id;
                            params.id = id;
                            return params
                        },
                    })
                },
            })
        },
        getAcceptOrgInfo:function (id) {
            var domain_id = $("#h-ca-amart-rules-domain-list").val();
            $.Hmodal({
                header:"费用接收方详细信息",
                height:"400px",
                width:"720px",
                body:$("#h-ca-amart-rules-accept-org-info-src").html(),
                footerBtnStatus:false,
                preprocess:function(){
                    $("#h-ca-amart-rules-accept-org-info-table-details").bootstrapTable({
                        height:300,
                        queryParams:function(params){
                            params.domain_id = domain_id;
                            params.rule_id = id;
                            return params
                        },
                    })
                },
            })
        },
        formatter:function (value,row,index) {
            var tmp = value.split("_join_")
            if (tmp.length == 2) {
                return tmp[1]
            } else {
                return tmp
            }
        },
        formattertype:function (value, row, index) {
            if (value == "0") {
                return "机构级"
            } else if (value == "1") {
                return "账户级"
            } else {
                return "-"
            }
        },
    };

    $(document).ready(function(){

        Hutils.InitDomain({
            id:"#h-ca-amart-rules-domain-list",
            height:"24px",
            width:"180px",
            onclick:function () {
                var id = $("#h-ca-amart-rules-domain-list").val();
                CaAmartRulesObj.tree(id);
            },
            callback:function (domainId) {
                $('#h-ca-amart-rules-info-table-details').bootstrapTable({
                    queryParams:function (params) {
                        params.domain_id = $("#h-ca-amart-rules-domain-list").val();
                        return params
                    },
                });
                CaAmartRulesObj.tree(domainId);
            }
        });
    });
</script>

<script type="text/html" id="h-ca-amart-rules-input-form">
    <form id="h-ca-amart-rule-form">
        <div class="hzwy23-page">
            <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px;">
                <label class="h-label" style="width:100%;">分摊规则编码：</label>
                <input placeholder="请输入1-30位数字，字母（必填）" name="rule_id" type="text" class="form-control" style="width: 100%;height: 30px;line-height: 30px;">
            </div>
            <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px;">
                <label class="h-label" style="width: 100%;">分摊规则名称：</label>
                <input placeholder="请填写分摊规则名称（必填）" type="text" class="form-control" name="rule_desc" style="width: 100%;height: 30px;line-height: 30px;">
            </div>

            <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px;">
                <label class="h-label" style="width: 100%;">分摊方式：</label>
                <select name="amart_mode" style="width: 100%;height: 30px;line-height: 30px;">
                    <option value="0">动因驱动分摊</option>
                    <option value="1">静态比例分摊</option>
                    <option value="2">费用占比分摊</option>
                </select>
            </div>

            <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px;">
                <label class="h-label" style="width: 100%;">分摊级别：</label>
                <select name="amart_type" style="width: 100%;height: 30px;line-height: 30px;">
                    <option value="0">机构级</option>
                    <option value="1">账户级</option>
                </select>
            </div>
        </div>

        <div class="hzwy23-page" style="display: none">
            <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px;">
                <label class="h-label" style="width: 100%;">费用摊出方：</label>
                <select name="org_unit_id" style="width: 100%;height: 30px;line-height: 30px;">
                </select>
            </div>
            <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px;">
                <label class="h-label" style="width: 100%;">成本信息：</label>
                <select name="cost_id" style="width: 100%;height: 30px;line-height: 30px;">
                </select>
            </div>
            <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px;">
                <label class="h-label" style="width: 100%;">费用摊出方-成本类别：</label>
                <select name="direction_id" style="width: 100%;height: 30px;line-height: 30px;">
                </select>
            </div>
        </div>
        <div class="hzwy23-page" style="display: none">
            <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px;">
                <label class="h-label" style="width: 100%;">费用接收方：</label>
                <select name="accept_org_unit_id" style="width: 100%;height: 30px;line-height: 30px;">
                </select>
                <input name="accept_org_list" style="display: none;"/>
            </div>
            <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px;">
                <label class="h-label" style="width: 100%;">费用接收方-成本类别：</label>
                <select name="accept_direction_id" style="width: 100%;height: 30px;line-height: 30px;">
                </select>
            </div>
        </div>
        <div class="hzwy23-page" style="display: none">
            <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px; display: none;">
                <label class="h-label" style="width: 100%;">静态分摊比例：</label>
                <select name="static_amart_id" style="width: 100%;height: 30px;line-height: 30px;">
                </select>
            </div>
            <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px; display: none;">
                <label class="h-label" style="width: 100%;">费用占比包含费用类别：</label>
                <select name="cost_proportion_id" style="width: 100%;height: 30px;line-height: 30px;">
                </select>
            </div>
            <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px; display: none;">
                <label class="h-label" style="width: 100%;">费用占比分摊处理费用比例(%)：</label>
                <input placeholder="处理费用的比例,必须是数字" type="number" name="cost_proportion_rate" class="form-control" style="width: 100%;height: 30px;line-height: 30px;">
            </div>
            <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px; border-bottom: #cccccc solid 1px;padding-bottom: 8px;">
                <label class="h-label" style="width: 100%;">动因编码：</label>
                <select name="driver_id" style="width: 100%;height: 30px;line-height: 30px;">
                </select>
            </div>
            <div class="col-sm-6 col-md-6 col-lg-6" style="margin-top: 8px; border-bottom: #cccccc solid 1px;padding-bottom: 8px;">
                <label class="h-label" style="width: 100%;">分摊费用比例(%)：</label>
                <input placeholder="请输入处理费用比例，必须是小于或等于100的数字（必填）" type="number" class="form-control" name="radio" style="width: 100%;height: 30px;line-height: 30px;">
            </div>
            <div class="col-sm-12 col-md-12 col-lg-12" style="margin-top: 8px;">
                <button id="h-ca-amart-rules-add-driver" type="button" onclick="CaAmartRulesObj.addDriver(this)" class="btn btn-success" title="添加动因"><i class="icon-plus"></i></button>
            </div>
        </div>
        <input name="domain_id"  style="display: none;"/>
    </form>
</script>

<script id="h-ca-amart-rules-driver-info-src" type="text/html">
    <table id="h-ca-amart-rules-driver-info-table-details"
           data-toggle="table"
           data-striped="true"
           data-url="/v1/ca/amart/rules/driver/get"
           data-side-pagination="client"
           data-pagination="false"
           data-search="false">
        <thead>
        <tr>
            <th data-align="center" data-field="rule_id" data-formatter="CaAmartRulesObj.formatter">分摊规则编码</th>
            <th data-align="center" data-field="driver_id" data-formatter="CaAmartRulesObj.formatter">动因编码</th>
            <th data-align="center" data-field="driver_desc">动因名称</th>
            <th data-align="center" data-field="rate">分摊费用比例(%)</th>
        </tr>
        </thead>
    </table>
</script>


<script id="h-ca-amart-rules-static-info-src" type="text/html">
    <table id="h-ca-amart-rules-static-info-table-details"
           data-toggle="table"
           data-striped="true"
           data-url="/v1/ca/static/config/get"
           data-side-pagination="client"
           data-pagination="false"
           data-search="false">
        <thead>
        <tr>
            <th data-align="center" data-field="static_amart_id" data-formatter="CaAmartRulesObj.formatter">静态规则编码</th>
            <th data-align="center" data-field="amart_accept_id" data-formatter="CaAmartRulesObj.formatter">费用接收方编码</th>
            <th data-align="center" data-field="amart_accept_desc">费用接收方名称</th>
            <th data-align="center" data-field="radio">接收比例(%)</th>
        </tr>
        </thead>
    </table>
</script>

<script id="h-ca-amart-rules-cost-info-src" type="text/html">
    <table id="h-ca-amart-rules-cost-info-table-details"
           data-toggle="table"
           data-striped="true"
           data-url="/v1/ca/amart/rules/cost/get"
           data-side-pagination="client"
           data-pagination="false"
           data-search="false">
        <thead>
        <tr>
            <th data-align="center" data-field="rule_id" data-formatter="CaAmartRulesObj.formatter">分摊规则编码</th>
            <th data-align="center" data-field="cost_proportion_id" data-formatter="CaAmartRulesObj.formatter">占比-成本类别编码</th>
            <th data-align="center" data-field="cost_proportion_desc">占比-成本类别名称</th>
            <th data-align="center" data-field="cost_proportion_rate">参与分摊费用比例(%)</th>
        </tr>
        </thead>
    </table>
</script>


<script id="h-ca-amart-rules-accept-org-info-src" type="text/html">
    <table id="h-ca-amart-rules-accept-org-info-table-details"
           data-toggle="table"
           data-striped="true"
           data-url="/v1/ca/amart/rules/org/accept"
           data-side-pagination="client"
           data-pagination="false"
           data-search="false">
        <thead>
        <tr>
            <th data-align="center" data-field="rule_id" data-formatter="CaAmartRulesObj.formatter">分摊规则</th>
            <th data-align="center" data-field="accept_org_unit_id" data-formatter="CaAmartRulesObj.formatter">费用接收方编码</th>
            <th data-align="center" data-field="accept_org_unit_desc">费用接收方名称</th>
        </tr>
        </thead>
    </table>
</script>
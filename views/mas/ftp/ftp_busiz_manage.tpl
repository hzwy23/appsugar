<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">定价单元配置管理</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-left" style="height: 44px; line-height: 44px; width: 260px;">
        <span style="height: 30px; line-height: 30px; margin-top: 7px;display: inline" class="pull-left">所属域：</span>
        <select id="h-ftp-busiz-domain-list" class="form-control pull-left" style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
        </select>
    </div>
    <div class="pull-right">
        <button onclick="FtpBusizObj.add()" class="btn btn-info btn-sm" title="新增机构信息">
            <i class="icon-plus"> 新增</i>
        </button>
        <button onclick="FtpBusizObj.upload()" class="btn btn-info btn-sm" title="导入机构信息">
            <span class="icon-edit"> 导入</span>
        </button>
        <button onclick="FtpBusizObj.download()" class="btn btn-info btn-sm" title="导出机构信息">
            <span class="icon-trash"> 导出</span>
        </button>
        <button onclick="FtpBusizObj.edit()" class="btn btn-info btn-sm" title="编辑机构信息">
            <span class="icon-edit"> 编辑</span>
        </button>
        <button onclick="FtpBusizObj.delete()" class="btn btn-danger btn-sm" title="删除机构信息">
            <span class="icon-trash"> 删除</span>
        </button>
    </div>
</div>
<div class="subsystem-content">
    <div class="row">
        <div class="col-sm-12 col-md-12 col-md-4">
            <div id="h-ftp-busiz-info-tree-info" class="thumbnail">
                <div class="col-ms-12 col-md-12 col-lg-12">
                    <div style="border-bottom: #598f56 solid 1px;height: 44px; line-height: 44px;">
                        <div class="pull-left">
                            <span><i class="icon-sitemap"> </i>定价规则树</span>
                        </div>
                        <div class="pull-right">
                    <span>
                        <i class=" icon-search" style="margin-top: 15px;"></i>&nbsp;
                    </span>
                        </div>
                    </div>
                </div>
                <div id="h-ftp-busiz-info-tree-info-list" class="col-sm-12 col-md-12 col-lg-12"
                     style="padding:15px 5px;overflow: auto">
                </div>
            </div>
        </div>
        <div id="h-ftp-busiz-info-table-info" class="col-sm-12 col-md-12 col-lg-8" style="padding-left: 0px;">
            <table id="h-ftp-busiz-info-table-details"
                   data-toggle="table"
                   data-side-pagination="client"
                   data-striped="true"
                   data-click-to-select="true"
                   data-pagination="true"
                   data-unique-id="busiz_id"
                   data-query-params="FtpBusizObj.queryParams"
                   data-page-list="[20, 50, 100, 200]"
                   data-search="false">
                <thead>
                <tr>
                    <th data-field="state" data-checkbox="true"></th>
                    <th data-field="code_number">定价单元编码</th>
                    <th data-field="busiz_desc">定价单元描述</th>
                    <th data-align="center" data-formatter="FtpBusizObj.typeFormatter">属性</th>
                    <th data-field="busiz_up_id" data-formatter="FtpBusizObj.upBusizId">上级编码</th>
                    <th data-field="ftp_method_id" data-formatter="FtpBusizObj.methodFormatter">定价方法</th>
                    <th data-field="curve_desc">选配曲线</th>
                    <th data-align="center" data-formatter="FtpBusizObj.termformatter">指定期限</th>
                    <th data-field="point_val">利差(BP)</th>
                    <th data-align="center" data-formatter="FtpBusizObj.flagformatter">是否定价</th>
                </tr>
                </thead>
            </table>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        var hwindow = document.documentElement.clientHeight;
        $("#h-ftp-busiz-info-tree-info").height(hwindow-139);
        $("#h-ftp-busiz-info-table-info").height(hwindow-139);
        $("#h-ftp-busiz-info-tree-info-list").height(hwindow-214);
        // 使用js初始化bootstrapTable
        // 获取用户默认能够访问到的数据信息
        $("#h-ftp-busiz-info-table-details").bootstrapTable({
            height:document.documentElement.clientHeight-130,
            url:'/v1/ftp/rules/manage/get',
        });
    });

    var FtpBusizObj = {
        $table:$('#h-ftp-busiz-info-table-details'),
        add:function(){
            $.Hmodal({
                body:$("#h-ftp-busiz-manage-input-form").html(),
                width:"420px",
                header:"新增定价单元信息",
                callback:function(hmode){

                    var $rowObj = $("#h-ftp-busiz-rep-form").find(".row");
                    var redemptionCurveList = new Array();
                    $rowObj.each(function (index, element) {
                        var e = {};
                        e.term_cd = $(element).find("input[name='redemption_term_cd']").val();
                        e.term_cd_mult = $(element).find("hzwy").attr("data-id");
                        e.weight = $(element).find("input[name='redemption_weight']").val();
                        redemptionCurveList.push(e);
                    });

                    var inputForm = document.getElementById("h-ftp-busiz-info-add");
                    var ftpRuleObj = {};
                    ftpRuleObj.busiz_id=inputForm.busiz_id.value;
                    ftpRuleObj.busiz_desc=inputForm.busiz_desc.value;
                    ftpRuleObj.busiz_up_id=inputForm.busiz_up_id.value;
                    ftpRuleObj.busiz_type=inputForm.busiz_attr.value;
                    ftpRuleObj.ftp_flag=inputForm.ftp_flag.value;
                    ftpRuleObj.ftp_method_id=inputForm.ftp_method_id.value;
                    ftpRuleObj.curve_id=inputForm.curve_id.value;
                    ftpRuleObj.term_cd=inputForm.term_cd.value;
                    ftpRuleObj.term_cd_mult=inputForm.term_cd_mult.value;
                    ftpRuleObj.point_val=inputForm.point_val.value;
                    ftpRuleObj.domain_id=inputForm.domain_id.value;
                    ftpRuleObj.redemption_list = redemptionCurveList;

                    $.HAjaxRequest({
                        url:"/v1/ftp/rules/manage/post",
                        data:{JSON:JSON.stringify(ftpRuleObj)},
                        type:"post",
                        success:function () {
                            $.Notify({
                                message:"新增定价规则信息成功",
                                type:"success"
                            });
                            $(hmode).remove();
                            var domain_id = $("#h-ftp-busiz-domain-list").val();
                            FtpBusizObj.tree(domain_id);
                            FtpBusizObj.$table.bootstrapTable("refresh")
                        }
                    })
                },
                preprocess:function(){

                    var domain_id = $("#h-ftp-busiz-domain-list").val();
                    var domainObj = document.getElementById("h-ftp-busiz-info-add");
                    domainObj.domain_id.value = domain_id;

                    $.getJSON("/v1/ftp/rules/manage/nodes/get",{
                        domain_id:domain_id
                    },function(data){
                        var arr = new Array();
                        $(data).each(function(index,element){
                            var ijs = {}
                            ijs.id=element.busiz_id;
                            ijs.text=element.busiz_desc;
                            ijs.upId=element.busiz_up_id;
                            arr.push(ijs)
                        });

                        var ijs = {};
                        ijs.id="-1";
                        ijs.text="定价规则树根节点";
                        ijs.upId="##hzwy23##";
                        arr.push(ijs)

                        $("#h-ftp-busiz-up-id-form").Hselect({
                            data:arr,
                            height:"30px"
                        })
                    });

                    $.getJSON("/v1/ftp/curve/define/list",{
                        domain_id:domain_id
                    },function (data) {
                        var arr = new Array()
                        $(data).each(function (index, element) {
                            var e = {}
                            e.id=element.curve_id
                            e.text = element.curve_desc
                            e.upId = "##hzwy23##"
                            arr.push(e)
                        });
                        $("#h-ftp-busiz-curve-id-form").Hselect({
                            height:"30px",
                            data:arr,
                        })
                    });


                    $("#h-ftp-busiz-method-list-form").Hselect({
                        value:"102",
                        height:"30px",
                        onclick:function () {
                           var ftp_method_id = $("#h-ftp-busiz-method-list-form").val();
                           switch (ftp_method_id){
                               case "101":
                                   $("#h-ftp-busiz-curve-id-form").parent().show()
                                   $("#h-ftp-busiz-method-list-form").parent().show()
                                   $("#h-ftp-busiz-flag-form").parent().show()
                                   $("#h-ftp-special-term-cn-form").show()
                                   $("#h-ftp-busiz-term-mult-form").parent().show()
                                   $("#h-ftp-busiz-rep-form").hide()
                                   $("#h-ftp-busiz-point-val-form").hide()
                                   break;
                               case "102":
                               case "105":
                               case "103":
                                   $("#h-ftp-busiz-curve-id-form").parent().show()
                                   $("#h-ftp-busiz-method-list-form").parent().show()
                                   $("#h-ftp-busiz-flag-form").parent().show()
                                   $("#h-ftp-special-term-cn-form").hide()
                                   $("#h-ftp-busiz-term-mult-form").parent().hide()
                                   $("#h-ftp-busiz-rep-form").hide()
                                   $("#h-ftp-busiz-point-val-form").hide()
                                   break;
                               case "104":
                                   $("#h-ftp-busiz-curve-id-form").parent().show()
                                   $("#h-ftp-busiz-method-list-form").parent().show()
                                   $("#h-ftp-busiz-flag-form").parent().show()
                                   $("#h-ftp-special-term-cn-form").hide()
                                   $("#h-ftp-busiz-term-mult-form").parent().hide()
                                   $("#h-ftp-busiz-rep-form").show()
                                   $("#h-ftp-busiz-point-val-form").hide()
                                   break;
                               case "106":
                                   $("#h-ftp-busiz-curve-id-form").parent().hide()
                                   $("#h-ftp-busiz-method-list-form").parent().show()
                                   $("#h-ftp-busiz-flag-form").parent().show()
                                   $("#h-ftp-special-term-cn-form").hide()
                                   $("#h-ftp-busiz-term-mult-form").parent().hide()
                                   $("#h-ftp-busiz-rep-form").hide()
                                   $("#h-ftp-busiz-point-val-form").show()
                                   break;
                               default:
                                   $.Notify({
                                       title:"温馨提示：",
                                       message:"定价方法异常",
                                       type:"info",
                                   })
                           }
                        },
                    });

                    $("#h-ftp-busiz-attr-form").Hselect({
                        value:"1",
                        height:"30px",
                        onclick:function () {
                            var busiz_attr = $("#h-ftp-busiz-attr-form").val();
                            if (busiz_attr == 0) {
                                $("#h-ftp-busiz-curve-id-form").parent().hide()
                                $("#h-ftp-special-term-cn-form").hide()
                                $("#h-ftp-busiz-method-list-form").parent().hide()
                                $("#h-ftp-busiz-flag-form").parent().hide()
                                $("#h-ftp-busiz-term-mult-form").parent().hide()
                                $("#h-ftp-busiz-rep-form").hide()
                                $("#h-ftp-busiz-point-val-form").hide()
                            } else if (busiz_attr == 1){
                                $("#h-ftp-busiz-curve-id-form").parent().show()
                                $("#h-ftp-busiz-method-list-form").parent().show()
                                $("#h-ftp-busiz-flag-form").parent().show()
                                $("#h-ftp-special-term-cn-form").hide()
                                $("#h-ftp-busiz-term-mult-form").parent().hide()
                                $("#h-ftp-busiz-rep-form").hide()
                                $("#h-ftp-busiz-point-val-form").hide()
                            } else {
                                $.Notify({
                                    title:"温馨提示：",
                                    message:"定价单元节点信息异常",
                                    type:"info",
                                })
                            }
                        },
                    });

                    $("#h-ftp-busiz-flag-form").Hselect({
                        value:"0",
                        height:"30px",
                        onclick:function () {
                            var ftp_flag = $("#h-ftp-busiz-flag-form").val();
                            // 定价
                            if (ftp_flag == 0) {
                                $("#h-ftp-busiz-curve-id-form").parent().show()
                                $("#h-ftp-special-term-cn-form").hide()
                                $("#h-ftp-busiz-method-list-form").parent().show()
                                $("#h-ftp-busiz-flag-form").parent().show()
                                $("#h-ftp-busiz-term-mult-form").parent().hide()
                                $("#h-ftp-busiz-rep-form").hide()
                                $("#h-ftp-busiz-point-val-form").hide()
                            } else if (ftp_flag == 1){
                                // 不定价
                                $("#h-ftp-busiz-flag-form").parent().show()
                                $("#h-ftp-busiz-curve-id-form").parent().hide()
                                $("#h-ftp-busiz-method-list-form").parent().hide()
                                $("#h-ftp-special-term-cn-form").hide()
                                $("#h-ftp-busiz-term-mult-form").parent().hide()
                                $("#h-ftp-busiz-rep-form").hide()
                                $("#h-ftp-busiz-point-val-form").hide()
                            } else {
                                $.Notify({
                                    title:"温馨提示：",
                                    message:"定价单元节点信息异常",
                                    type:"info",
                                })
                            }
                        },
                    });

                    $("#h-ftp-busiz-term-mult-form").Hselect({
                        value:"M",
                        height:"30px",
                    });

                }
            })
        },
        edit:function () {
            var rows = $("#h-ftp-busiz-info-table-details").bootstrapTable('getSelections');
            if (rows.length === 0) {
                var selected = $("#h-ftp-busiz-info-tree-info-list").attr("data-selected")
                if (selected == null) {
                    $.Notify({
                        message:"请选择一个定价单元进行编辑",
                        type:"info"
                    });
                    return;
                }
                rows.push($("#h-ftp-busiz-info-table-details").bootstrapTable('getRowByUniqueId',selected))
            } else if ( rows.length > 1) {
                $.Notify({
                    message:"只能选择<span style='color: red; font-weight: 600;'>一项</span>进行编辑",
                    type:"info"
                });
                return;
            }

            $.Hmodal({
                body:$("#h-ftp-busiz-manage-input-form").html(),
                width:"420px",
                header:"编辑定价单元信息",
                callback:function(hmode){
                    var $rowObj = $("#h-ftp-busiz-rep-form").find(".row");
                    var redemptionCurveList = new Array();
                    $rowObj.each(function (index, element) {
                        var e = {};
                        e.term_cd = $(element).find("input[name='redemption_term_cd']").val();
                        e.term_cd_mult = $(element).find("hzwy").attr("data-id");
                        e.weight = $(element).find("input[name='redemption_weight']").val();
                        redemptionCurveList.push(e);
                    });

                    var inputForm = document.getElementById("h-ftp-busiz-info-add");
                    var ftpRuleObj = {};
                    ftpRuleObj.busiz_id=inputForm.busiz_id.value;
                    ftpRuleObj.busiz_desc=inputForm.busiz_desc.value;
                    ftpRuleObj.busiz_up_id=inputForm.busiz_up_id.value;
                    ftpRuleObj.busiz_type=inputForm.busiz_attr.value;
                    ftpRuleObj.ftp_flag=inputForm.ftp_flag.value;
                    ftpRuleObj.ftp_method_id=inputForm.ftp_method_id.value;
                    ftpRuleObj.curve_id=inputForm.curve_id.value;
                    ftpRuleObj.term_cd=inputForm.term_cd.value;
                    ftpRuleObj.term_cd_mult=inputForm.term_cd_mult.value;
                    ftpRuleObj.point_val=inputForm.point_val.value;
                    ftpRuleObj.domain_id=inputForm.domain_id.value;
                    ftpRuleObj.redemption_list = redemptionCurveList;

                    $.HAjaxRequest({
                        url:"/v1/ftp/rules/manage/put",
                        data:{JSON:JSON.stringify(ftpRuleObj)},
                        type:"put",
                        success:function () {
                            $.Notify({
                                message:"编辑定价规则信息成功",
                                type:"success"
                            });
                            $(hmode).remove();
                            var domain_id = $("#h-ftp-busiz-domain-list").val();
                            FtpBusizObj.tree(domain_id)
                        }
                    })
                },
                preprocess:function(){

                    var domain_id = $("#h-ftp-busiz-domain-list").val();
                    var domainObj = document.getElementById("h-ftp-busiz-info-add");
                    domainObj.domain_id.value = domain_id;

                    $.getJSON("/v1/ftp/rules/manage/nodes/get",{
                        domain_id:domain_id
                    },function(data){
                        var arr = new Array();
                        $(data).each(function(index,element){
                            var ijs = {};
                            ijs.id=element.busiz_id;
                            ijs.text=element.busiz_desc;
                            ijs.upId=element.busiz_up_id;
                            arr.push(ijs)
                        });

                        var ijs = {};
                        ijs.id="-1";
                        ijs.text="定价规则树根节点";
                        ijs.upId="##hzwy23##";
                        arr.push(ijs);

                        $("#h-ftp-busiz-up-id-form").Hselect({
                            data:arr,
                            height:"30px",
                            value:rows[0].busiz_up_id
                        })
                    });

                    // 叶子，结点信息
                    $("#h-ftp-busiz-attr-form").Hselect({
                        value:"1",
                        height:"30px",
                        value:rows[0].busiz_type,
                        disabled:true
                    });

                    if (rows[0].busiz_type == 1){
                        // 叶子信息
                        // 获取曲线信息
                        $.getJSON("/v1/ftp/curve/define/list",{
                            domain_id:domain_id
                        },function (data) {
                            var arr = new Array();
                            $(data).each(function (index, element) {
                                var e = {};
                                e.id=element.curve_id;
                                e.text = element.curve_desc;
                                e.upId = "##hzwy23##";
                                arr.push(e)
                            });
                            $("#h-ftp-busiz-curve-id-form").Hselect({
                                height:"30px",
                                data:arr,
                                value:rows[0].curve_id
                            })
                        });

                        // 获取定价方法
                        $("#h-ftp-busiz-method-list-form").Hselect({
                            value:"102",
                            height:"30px",
                            onclick:function () {
                                var ftp_method_id = $("#h-ftp-busiz-method-list-form").val();
                                switch (ftp_method_id){
                                    case "101":
                                        $("#h-ftp-busiz-curve-id-form").parent().show();
                                        $("#h-ftp-busiz-method-list-form").parent().show();
                                        $("#h-ftp-busiz-flag-form").parent().show();
                                        $("#h-ftp-special-term-cn-form").show();
                                        $("#h-ftp-busiz-term-mult-form").parent().show();
                                        $("#h-ftp-busiz-rep-form").hide();
                                        $("#h-ftp-busiz-point-val-form").hide();
                                        break;
                                    case "102":
                                    case "105":
                                    case "103":
                                        $("#h-ftp-busiz-curve-id-form").parent().show();
                                        $("#h-ftp-busiz-method-list-form").parent().show();
                                        $("#h-ftp-busiz-flag-form").parent().show();
                                        $("#h-ftp-special-term-cn-form").hide();
                                        $("#h-ftp-busiz-term-mult-form").parent().hide();
                                        $("#h-ftp-busiz-rep-form").hide();
                                        $("#h-ftp-busiz-point-val-form").hide();
                                        break;
                                    case "104":
                                        $("#h-ftp-busiz-curve-id-form").parent().show();
                                        $("#h-ftp-busiz-method-list-form").parent().show();
                                        $("#h-ftp-busiz-flag-form").parent().show();
                                        $("#h-ftp-special-term-cn-form").hide();
                                        $("#h-ftp-busiz-term-mult-form").parent().hide();
                                        $("#h-ftp-busiz-rep-form").show();
                                        $("#h-ftp-busiz-point-val-form").hide();
                                        break;
                                    case "106":
                                        $("#h-ftp-busiz-curve-id-form").parent().hide();
                                        $("#h-ftp-busiz-method-list-form").parent().show();
                                        $("#h-ftp-busiz-flag-form").parent().show();
                                        $("#h-ftp-special-term-cn-form").hide();
                                        $("#h-ftp-busiz-term-mult-form").parent().hide();
                                        $("#h-ftp-busiz-rep-form").hide();
                                        $("#h-ftp-busiz-point-val-form").show();
                                        break;
                                }
                            }
                        });
                    }

                    if (rows[0].busiz_type == 0) {
                        // 结点
                        $("#h-ftp-busiz-curve-id-form").parent().hide();
                        $("#h-ftp-special-term-cn-form").hide();
                        $("#h-ftp-busiz-method-list-form").parent().hide();
                        $("#h-ftp-busiz-flag-form").parent().hide();
                        $("#h-ftp-busiz-term-mult-form").parent().hide();
                        $("#h-ftp-busiz-rep-form").hide();
                        $("#h-ftp-busiz-point-val-form").hide();

                        $("#h-ftp-busiz-flag-form").Hselect({
                            value: "0",
                            height: "30px",
                            data:[{id:"1",text:"不定价",upId:"-1"}],
                            disabled:true,
                        });
                    } else if (rows[0].busiz_type == 1){
                        // 叶子
                        $("#h-ftp-busiz-curve-id-form").parent().show();
                        $("#h-ftp-busiz-method-list-form").parent().show();
                        $("#h-ftp-busiz-flag-form").parent().show();
                        $("#h-ftp-special-term-cn-form").hide();
                        $("#h-ftp-busiz-term-mult-form").parent().hide();
                        $("#h-ftp-busiz-rep-form").hide();
                        $("#h-ftp-busiz-point-val-form").hide();

                        $("#h-ftp-busiz-flag-form").Hselect({
                            value:"0",
                            height:"30px",
                            onclick:function () {
                                var ftp_flag = $("#h-ftp-busiz-flag-form").val();
                                // 定价
                                if (ftp_flag == 0) {
                                    $("#h-ftp-busiz-curve-id-form").parent().show()
                                    $("#h-ftp-special-term-cn-form").hide()
                                    $("#h-ftp-busiz-method-list-form").parent().show()
                                    $("#h-ftp-busiz-flag-form").parent().show()
                                    $("#h-ftp-busiz-term-mult-form").parent().hide()
                                    $("#h-ftp-busiz-rep-form").hide()
                                    $("#h-ftp-busiz-point-val-form").hide()
                                } else if (ftp_flag == 1){
                                    // 不定价
                                    $("#h-ftp-busiz-flag-form").parent().show()
                                    $("#h-ftp-busiz-curve-id-form").parent().hide()
                                    $("#h-ftp-busiz-method-list-form").parent().hide()
                                    $("#h-ftp-special-term-cn-form").hide()
                                    $("#h-ftp-busiz-term-mult-form").parent().hide()
                                    $("#h-ftp-busiz-rep-form").hide()
                                    $("#h-ftp-busiz-point-val-form").hide()
                                } else {
                                    $.Notify({
                                        message:"定价单元节点信息异常",
                                        type:"info",
                                    })
                                }
                            }
                        });
                    } else {
                        $.Notify({
                            message:"定价单元节点信息异常",
                            type:"info",
                        })
                    }

                    // 单位信息
                    $("#h-ftp-busiz-term-mult-form").Hselect({
                        value:"M",
                        height:"30px",
                        value:rows[0].term_cd_mult
                    });

                    $("#h-ftp-busiz-info-add").find("input[name='busiz_id']")
                        .val(rows[0].code_number)
                        .attr("readonly","readonly");

                    $("#h-ftp-busiz-info-add").find("input[name='busiz_desc']")
                        .val(rows[0].busiz_desc);
                    $("#h-ftp-busiz-info-add").find("input[name='term_cd']")
                        .val(rows[0].term_cd);

                    $("#h-ftp-busiz-flag-form").val(rows[0].ftp_flag).trigger("change");
                    $("#h-ftp-busiz-method-list-form").val(rows[0].ftp_method_id).trigger("change");
                    $("#point_val").val(rows[0].point_val);

                    $.getJSON("/v1/ftp/rules/redemption/get",{
                        busiz_id:rows[0].busiz_id,
                        domain_id:rows[0].domain_id
                    },function (data) {
                        $(data).each(function (index, element) {
                            if (index == 0) {
                                var $firstObj = $("#h-ftp-busiz-rep-form").find(".row:eq(0)");
                                $firstObj.find("input[name='redemption_term_cd']").val(element.term_cd);
                                $firstObj.find("hzwy").attr("data-id",element.term_cd_mult);
                                if (element.term_cd_mult == "D") {
                                    $firstObj.find("hzwy").html("日")
                                } else if(element.term_cd_mult == "M"){
                                    $firstObj.find("hzwy").html("月")
                                }else {
                                    $firstObj.find("hzwy").html("年")
                                }
                                $firstObj.find("input[name='redemption_weight']").val(element.weight);
                            } else {
                                var obj = $("#h-ftp-busiz-manager-redemption-src").html();
                                $("#h-ftp-busiz-rep-form").append(obj);

                                var $firstObj = $("#h-ftp-busiz-rep-form").find(".row:eq("+index+")");
                                $firstObj.find("input[name='redemption_term_cd']").val(element.term_cd);
                                $firstObj.find("hzwy").attr("data-id",element.term_cd_mult);
                                if (element.term_cd_mult == "D") {
                                    $firstObj.find("hzwy").html("日")
                                } else if(element.term_cd_mult == "M"){
                                    $firstObj.find("hzwy").html("月")
                                }else {
                                    $firstObj.find("hzwy").html("年")
                                }
                                $firstObj.find("input[name='redemption_weight']").val(element.weight);
                            }
                        })
                    });
                }
            })
        },
        getSubBusiz:function(set,all){

            var addArray = new Array();

            var search = function(obj,arr){
                $(arr).each(function(index,element){
                    if (obj.busiz_id == element.busiz_up_id){
                        addArray.push(element)
                        var newArray = all.splice(index,1)
                        search(element,newArray)
                    }
                });
            };

            $(set).each(function(index,element){
                search(element,all)
            });

            return addArray
        },
        delete:function () {
            var domain_id = $("#h-ftp-busiz-domain-list").val();

            var data = FtpBusizObj.$table.bootstrapTable("getSelections").concat();
            var alldata = FtpBusizObj.$table.bootstrapTable('getData');

            // 将数组中的值复制一份
            var all = alldata.concat()
            if (data.length == 0){
                $.Notify({
                    message:"您没有在下列责任中心信息表中选择需要删除的机构",
                    type:"info",
                });
                return
            } else {
                $.Hconfirm({
                    preprocess:function () {

                        var deletedata = FtpBusizObj.getSubBusiz(data,all);

                        $(deletedata).each(function (index, element) {
                            data.push(element)
                        });

                    },
                    callback:function () {
                        $.HAjaxRequest({
                            url:"/v1/ftp/rules/manage/delete",
                            type:"post",
                            data:{JSON:JSON.stringify(data),domain_id:domain_id},
                            success:function () {
                                $.Notify({
                                    title:"温馨提示：",
                                    message:"删除机构信息成功",
                                    type:"success",
                                });
                                FtpBusizObj.$table.bootstrapTable("refresh")
                                FtpBusizObj.tree(domain_id)
                            }
                        })
                    },
                    body:"点击确认删除选中的定价单元信息"
                })
            }
        },
        // table表中信息查询参数
        queryParams:function (params) {
            params.domain_id = $("#h-ftp-busiz-domain-list").val();
            return params
        },
        download:function(){
            var domain_id = $("#h-ftp-busiz-domain-list").val()
            var x=new XMLHttpRequest();
            x.open("GET", "/v1/auth/resource/org/download?domain_id="+domain_id, true);
            x.responseType = 'blob';
            x.onload=function(e){
                download(x.response, "机构信息.xlsx", "application/vnd.ms-excel" );
            };
            x.send();
        },
        upload:function(){
            $.Notify({
                message:"目前没有权限使用导出数据功能",
                type:"info",
            })
        },
        tree:function(domain_id){
            $.getJSON("/v1/ftp/rules/manage/get",{
                domain_id:domain_id
            },function(data){
                if (data.length==0){
                    FtpBusizObj.$table.bootstrapTable('load',[])
                    $("#h-ftp-busiz-info-tree-info-list").Htree({
                        data:[]
                    })
                } else {
                    var arr = new Array();
                    $(data).each(function(index,element){
                        var ijs = {};
                        ijs.id = element.busiz_id;
                        ijs.text = element.busiz_desc;
                        ijs.upId = element.busiz_up_id;
                        if (element.busiz_type == "0"){
                            ijs.attr = "1"
                        } else {
                            ijs.attr = "0"
                        }
                        arr.push(ijs)
                    });
                    $("#h-ftp-busiz-info-tree-info-list").HtreeWithLine({
                        data:arr,
                        onChange:function(obj){
                            var id = $(obj).attr("data-id");
                            $.getJSON("/v1/ftp/rules/manage/sub/query",{
                                busiz_id:id
                            },function(data) {
                                FtpBusizObj.$table.bootstrapTable('load',data)
                            });
                        }
                    });
                    $("#h-ftp-busiz-info-table-details").bootstrapTable('load',data);
                }
            })
        },
        upBusizId:function(value,row,index){
            var upcombine = row.busiz_up_id.split("_join_")
            if (upcombine.length==2){
                return upcombine[1]
            }else{
                return upcombine
            }
        },
        deleteRedemptionValue:function (obj) {
            $(obj).parent().parent().remove();
        },
        setRedemptionValue:function (busiz_id) {
            var obj = $("#h-ftp-busiz-manager-redemption-src").html();
            $("#h-ftp-busiz-rep-form").append(obj);
        },
        methodFormatter:function (value,row,index) {
            switch (row.ftp_method_id) {
                case "101":
                    return "指定期限法"
                case "102":
                    return "直接期限匹配法"
                case "103":
                    return "现金流加权期限发"
                case "104":
                    return "偿还曲线法"
                case "105":
                    return "久期法"
                case "106":
                    return "利率代码差额法"
                default:
                    return "<span>-</span>"
            }
        },
        termformatter:function (value, row, index) {
            if (row.ftp_method_id == "104"){
                return "<span onclick='FtpBusizObj.getRedemptionCurve(\""+row.busiz_id+"\",\""+row.domain_id+"\")' style='height: 14px; line-height: 14px; cursor: pointer;' class='btn-xs btn-success'>查看</span>"
            }
            if (row.ftp_method_id == "101"){
                return row.term_cd+row.term_cd_mult
            }

        },
        getRedemptionCurve:function (busiz_id,domain_id) {
            $.Hmodal({
                header:"偿还曲线参数信息",
                width:"520px",
                footerBtnStatus:false,
                body:$("#h-ftp-busiz-manager-redemption-show-src").html(),
                preprocess:function () {
                    $("#h-ftp-busiz-manager-redemption-show-table").bootstrapTable({
                        queryParams:function (params) {
                            params.busiz_id = busiz_id;
                            params.domain_id = domain_id;
                            return params;
                        },
                        url:"/v1/ftp/rules/redemption/get"
                    });
                }
            });

        },
        flagformatter:function (value, row, index){
            if (row.busiz_type == "0"){
                return "-"
            }
            switch (row.ftp_flag) {
                case "0":
                    return "<span style='color: #009966;font-weight: 600; font-size: 12px;'>定价</span>"
                case "1":
                    return "<span style='color: red;font-weight: 600; font-size: 12px;'>不定价</span>"
                default:
                    return "-"
            }
        },
        typeFormatter:function (value, row, index) {
            switch (row.busiz_type) {
                case "0":
                    return "结点"
                case "1":
                    return "叶子"
                default:
                    return "-"
            }
        },
        changeMult:function (obj) {
            var newId = $(obj).attr("data-id");
            var newHtml = $(obj).html();

            var $showObj = $(obj).parent().prev().find("hzwy");
            $showObj.html(newHtml);
            $showObj.attr("data-id",newId);
        }
    };

    $(document).ready(function(){

        Hutils.InitDomain({
            id:"#h-ftp-busiz-domain-list",
            height:"24px",
            width:"180px",
            onclick:function () {
                // 当选择框值改变信息触发时，执行这块函数
                var domain_id = $("#h-ftp-busiz-domain-list").val()
                // 根据所选择的的域，刷新左侧的树形展示区域
                FtpBusizObj.tree(domain_id);
                // 刷新bootstrapTable中数据信息
            },
            callback:function (domainId){
                // 初始化左侧树形展示区域信息。
                FtpBusizObj.tree(domainId);
            }
        });
    });
</script>

<script type="text/html" id="h-ftp-busiz-manage-input-form">
    <form class="row" id="h-ftp-busiz-info-add">
        <div class="col-sm-12">
            <label class="control-label" style="font-size: 12px;">定价单元编码：</label>
            <input placeholder="请输入1-30位数字，字母（必填）" name="busiz_id" type="text" class="form-control" style="width: 100%;height: 30px;line-height: 30px;">
        </div>

        <div class="col-sm-12" style="margin-top: 12px;">
            <label class="control-label" style="font-size: 12px;">定价单元名称：</label>
            <input placeholder="请输入1-60位汉字，字母，数字（必填）" type="text" class="form-control" name="busiz_desc" style="width: 100%;height: 30px;line-height: 30px;">
        </div>

        <div class="col-sm-12" style="margin-top: 12px;">
            <label class="control-label" style="font-size: 12px;">上级定价单元：</label>
            <select id="h-ftp-busiz-up-id-form" name="busiz_up_id" style="width: 100%;height: 30px;line-height: 30px;">
            </select>
        </div>

        <div class="col-sm-12" style="margin-top: 12px;">
            <label class="control-label" style="font-size: 12px;">属性类型：</label>
            <select id="h-ftp-busiz-attr-form" name="busiz_attr" style="width: 100%;height: 30px;line-height: 30px;">
                <option value="0">结点</option>
                <option value="1">叶子</option>
            </select>
        </div>

        <div class="col-sm-12" style="margin-top: 12px;">
            <label class="control-label" style="font-size: 12px;">是否定价：</label>
            <select id="h-ftp-busiz-flag-form" name="ftp_flag" style="width: 100%;height: 30px;line-height: 30px;">
                <option value="0">定价</option>
                <option value="1">不定价</option>
            </select>
        </div>

        <div class="col-sm-12" style="margin-top: 15px;">
            <label class="control-label" style="font-size: 12px;">定价方法：</label>
            <select id="h-ftp-busiz-method-list-form" name="ftp_method_id" style="width: 100%;height: 30px;line-height: 30px;">
                <option value="101">指定期限法</option>
                <option value="102">直接期限匹配法</option>
                <option value="103">现金流加权期限法</option>
                <option value="104">偿还曲线法</option>
                <option value="105">久期法</option>
                <option value="106">利率代码差额法</option>
            </select>
        </div>

        <div class="col-sm-12" style="margin-top: 15px;">
            <label class="control-label" style="font-size: 12px;">适配曲线：</label>
            <select id="h-ftp-busiz-curve-id-form" name="curve_id" style="width: 100%;height: 30px;line-height: 30px;">
            </select>
        </div>

        <div id="h-ftp-special-term-cn-form" class="col-sm-12" style="margin-top: 12px;display: none;">
            <label class="control-label" style="font-size: 12px;">指定期限：</label>
            <input placeholder="请输入期限值，必须是数字" name="term_cd" class="form-control" style="width: 100%;height: 30px;line-height: 30px;" />
        </div>

        <div class="col-sm-12" style="display: none;margin-top: 12px;">
            <label class="control-label" style="font-size: 12px;">指定期限单位：</label>
            <select id="h-ftp-busiz-term-mult-form" name="term_cd_mult" style="width: 100%;height: 30px;line-height: 30px;">
                <option value="D">日</option>
                <option value="M">月</option>
                <option value="Y">年</option>
            </select>
        </div>

        <div id="h-ftp-busiz-rep-form"
             class="col-sm-12"
             style="display: none; margin-top: 12px; background-color: #ffffff">
            <label class="control-label" style="font-size: 12px;">偿还曲线信息：</label>
            <div class="row">
                <div class="col-sm-10">
                    <div class="input-group">
                        <input placeholder="期限点，如 1" type="text"
                               name="redemption_term_cd"
                               class="form-control"
                               style="height: 30px; line-height: 30px;">
                        <div class="input-group-btn dropup">
                            <button type="button" class="btn btn-sm btn-default dropdown-toggle"
                                    data-toggle="dropdown" aria-haspopup="true"
                                    aria-expanded="false">
                                &nbsp;&nbsp;
                                <hzwy data-id="D">日</hzwy>
                                &nbsp;&nbsp;
                                <span class="caret"></span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-right">
                                <li class="hover-cursor" onclick="FtpBusizObj.changeMult(this)" style="height: 30px;line-height: 30px; cursor: pointer; padding-left: 15px;" data-id="D">日</li>
                                <li class="hover-cursor" onclick="FtpBusizObj.changeMult(this)" style="height: 30px;line-height: 30px; cursor: pointer; padding-left: 15px;" data-id="M">月</li>
                                <li class="hover-cursor" onclick="FtpBusizObj.changeMult(this)" style="height: 30px;line-height: 30px; cursor: pointer; padding-left: 15px;" data-id="Y">年</li>
                            </ul>
                        </div><!-- /btn-group -->
                        <input placeholder="权重值，如：0.5" type="text"
                               name="redemption_weight"
                               class="form-control" style="height: 30px; line-height: 30px;">
                    </div>
                </div>
                <div class="col-sm-2">
                <!--<button type="button" class="btn btn-danger btn-sm"><i class="icon-trash"></i></button>-->
                <button type="button" onclick="FtpBusizObj.setRedemptionValue()"
                class="btn btn-sm btn-success"><i class="icon-plus"></i></button>
                </div>
            </div>
        </div>

        <div id="h-ftp-busiz-point-val-form" class="col-sm-12" style="display: none;margin-top: 12px;">
            <label class="control-label" style="font-size: 12px;">利率代码差额值(BP)：</label>
            <input placeholder="单位：BP" id="point_val" name="point_val" class="form-control" style="width: 100%;height: 30px;line-height: 30px;" />
        </div>

        <input name="domain_id" style="display: none;" />
    </form>
</script>

<script id="h-ftp-busiz-manager-redemption-show-src" type="text/html">
    <table id="h-ftp-busiz-manager-redemption-show-table"
           data-toggle="table"
           data-side-pagination="client"
           data-striped="true"
           data-click-to-select="true"
           data-pagination="true"
           data-unique-id="uuid"
           data-page-list="[20, 50, 100, 200]"
           data-search="false">
        <thead>
        <tr>
            <th data-align="center" data-field="term_cd">期限点</th>
            <th data-align="center" data-field="term_cd_mult">期限单位</th>
            <th data-field="weight">权重（BP)</th>
        </tr>
        </thead>
    </table>
</script>

<script id="h-ftp-busiz-manager-redemption-src" type="text/html">
    <div class="row" style="margin-top: 6px; margin-bottom: 6px;">
        <div class="col-sm-10">
            <div class="input-group">
                <input placeholder="期限点，如 1" type="text"
                       name="redemption_term_cd"
                       class="form-control"
                       style="height: 30px; line-height: 30px;">
                <div class="input-group-btn dropup">
                    <button type="button" class="btn btn-sm btn-default dropdown-toggle"
                            data-toggle="dropdown" aria-haspopup="true"
                            aria-expanded="false">
                        &nbsp;&nbsp;
                        <hzwy data-id="D">日</hzwy>
                        &nbsp;&nbsp;
                        <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-right">
                        <li class="hover-cursor" onclick="FtpBusizObj.changeMult(this)" data-id="D">日</li>
                        <li class="hover-cursor" onclick="FtpBusizObj.changeMult(this)" data-id="M">月</li>
                        <li class="hover-cursor" onclick="FtpBusizObj.changeMult(this)" data-id="Y">年</li>
                    </ul>
                </div><!-- /btn-group -->
                <input placeholder="权重值，如：0.5" type="text"
                       name="redemption_weight"
                       class="form-control" style="height: 30px; line-height: 30px;">
            </div>
        </div>
        <div class="col-sm-2">
            <!--<button type="button" onclick="FtpBusizObj.setRedemptionValue()"-->
                    <!--class="btn btn-sm btn-success"><i class="icon-plus"></i></button>-->
            <button type="button" onclick="FtpBusizObj.deleteRedemptionValue(this)"
                    class="btn btn-danger btn-sm"><i class="icon-trash"></i></button>
        </div>
    </div>
</script>
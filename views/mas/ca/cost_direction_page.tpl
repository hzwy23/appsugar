<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">成本类别配置管理</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-left" style="height: 44px; line-height: 44px; width: 260px;">
        <span style="font-size: 10px;font-weight: 600;height: 30px; line-height: 30px; margin-top: 7px;display: inline" class="pull-left">&nbsp;&nbsp;所属域：</span>
        <select id="h-cost-direction-domain-list" class="form-control pull-left" style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
        </select>
    </div>
    <div class="pull-right">
        &nbsp;
        {{if checkResIDAuth "2" "0201030200"}}
        <button onclick="CaDirectionObj.add()" class="btn btn-info btn-sm" title="新增机构信息">
            <i class="icon-plus"> 新增</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0201030600"}}
        <button onclick="CaDirectionObj.upload()" class="btn btn-info btn-sm" title="导入机构信息">
            <span class="icon-edit"> 导入</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0201030500"}}
        <button onclick="CaDirectionObj.download()" class="btn btn-info btn-sm" title="导出机构信息">
            <span class="icon-trash"> 导出</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0201030300"}}
        <button onclick="CaDirectionObj.update()" class="btn btn-info btn-sm" title="编辑机构信息">
            <span class="icon-edit"> 编辑</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0201030400"}}
        <button onclick="CaDirectionObj.delete()" class="btn btn-danger btn-sm" title="删除机构信息">
            <span class="icon-trash"> 删除</span>
        </button>
        {{end}}
    </div>
</div>
<div class="subsystem-content" style="padding-top: 3px;">
	<div class="row">
		<div class="col-sm-12 col-md-5 col-lg-3">
	        <div id="h-ca-direction-tree-info" class="thumbnail">
	            <div class="col-ms-12 col-md-12 col-lg-12">
	                <div style="border-bottom: #598f56 solid 1px;height: 44px; line-height: 44px;">
	                    <div class="pull-left">
	                        <span><i class="icon-sitemap"> </i>成本类别树形结构</span>
	                    </div>
	                    <div class="pull-right">
	                    <span>
	                        <i class=" icon-search" style="margin-top: 15px;"></i>&nbsp;
	                    </span>
	                    </div>
	                </div>
	            </div>
	            <div id="h-ca-direction-tree-info-list" class="col-sm-12 col-md-12 col-lg-12"
	                 style="padding:15px 5px;overflow: auto">
	            </div>
	        </div>
	    </div>
	    <div class="col-sm-12 col-md-7 col-lg-9" style="padding-left: 0px;">
	        <div id="h-cost-direction-content">
	            <table id="h-cost-direction-info-table-details"
	                   data-toggle="table"
	                   data-striped="true"
                       data-click-to-select="true"
	                   data-unique-id="direction_id"
	                   data-side-pagination="client"
	                   data-pagination="false"
	                   data-search="false">
	                <thead>
	                <tr>
	                    <th data-field="state" data-checkbox="true"></th>
	                    <th data-sortable="true" data-field="code_number">成本类别编码</th>
	                    <th data-sortable="true" data-field="direction_desc">成本类别名称</th>
	                    <th data-sortable="true" data-field="direction_up_id" data-formatter="CaDirectionObj.formatterUpId">上级成本类别编码</th>
	                    <th data-sortable="true" data-align="center" data-field="direction_attr" data-formatter="CaDirectionObj.formatterattr">层级属性</th>
	                    <th data-sortable="true" data-align="center" data-field="create_date">创建日期</th>
	                    <th data-sortable="true" data-align="center" data-field="create_user">创建人</th>
	                    <th data-sortable="true" data-align="center" data-field="modify_date">修改日期</th>
	                    <th data-sortable="true" data-align="center" data-field="modify_user">修改人</th>
	                </tr>
	                </thead>
	            </table>
	        </div>
	    </div>
	</div>
</div>
<script type="text/javascript">

    var CaDirectionObj = {
        download:function () {
            var domain_id = $("#h-cost-direction-domain-list").val();
            var url = "/v1/ca/cost/direction/download?domain_id="+domain_id;
            $.Hdownload({
                url:url,
                name:"成本类别参数信息",
            })
        },
        upload:function () {
            $.Hupload({
                header:"成本类别参数上传",
                url:"/v1/ca/cost/direction/upload",
                callback:function () {
                    var domain_id = $("#h-cost-direction-domain-list").val();
                    CaDirectionObj.tree(domain_id);
                }
            })
        },
        add:function () {
            $.Hmodal({
                header:"新增成本类别参数",
                body:$("#h-ca-cost-direction-add-tmpl").html(),
                width:"420px",
                callback:function (hmode) {
                    $.HAjaxRequest({
                        url:"/v1/ca/cost/direction/post",
                        type:"post",
                        data:$("#h-ca-cost-direction-add-form").serialize(),
                        success:function () {
                            $.Notify({
                                message:"新增成本类别参数成功",
                                type:"success",
                            });
                            var domain_id = $("#h-cost-direction-domain-list").val();
                            CaDirectionObj.tree(domain_id);
                            $(hmode).remove();
                        }
                    })
                },
                preprocess:function () {

                    $("#h-ca-direction-add-attr").Hselect({
                        height:"30px",
                    });
                    var direction_id = $("#h-ca-direction-tree-info-list").attr("data-selected");

                    var domain_id = $("#h-cost-direction-domain-list").val();

                    $("#h-ca-cost-direction-add-form").find("input[name='domain_id']").val(domain_id)

                    // 获取域中的所有节点层面费用方向
                    $.getJSON("/v1/ca/cost/direction/nodes",{domain_id:domain_id},function (data) {
                        var arr = new Array()

                        $(data).each(function (index, element) {
                            var e = {}
                            e.id = element.direction_id;
                            e.text = element.direction_desc;
                            e.upId = element.direction_up_id;
                            arr.push(e);
                        });

                        var e = {};
                        e.id = "-1";
                        e.text = "系统树形根结点";
                        e.upId = "##hzwy23##";
                        arr.push(e);

                        $("#h-ca-direction-add-up-id").Hselect({
                            height:"30px",
                            data:arr,
                            value:direction_id,
                        })
                    })
                },
            })
        },
        delete:function () {
            var rows = $("#h-cost-direction-info-table-details").bootstrapTable('getSelections');
            if (rows.length == 0) {
                var direction_id = $("#h-ca-direction-tree-info-list").attr("data-selected");
                if (direction_id == undefined) {
                    $.Notify({
                        message:"请选择需要删除的成本类别",
                        type:"warning",
                    });
                    return
                }
                rows.push($("#h-cost-direction-info-table-details").bootstrapTable('getRowByUniqueId',direction_id))
            }

            $.Hconfirm({
                body:"点击确定,将会删除此成本类别参数,<br/>这个成本类别的下级成本类别参数也会一同删除",
                callback:function () {
                    $.HAjaxRequest({
                        url:"/v1/ca/cost/direction/delete",
                        type:"POST",
                        data:{JSON:JSON.stringify(rows)},
                        success:function () {
                            $.Notify({
                                message:"删除成本类别参数成功",
                                type:"success",
                            });
                            var domain_id = $("#h-cost-direction-domain-list").val();
                            CaDirectionObj.tree(domain_id);
                            $("#h-ca-direction-tree-info-list").removeAttr("data-selected")
                        },
                    })
                },
            })
        },
        update:function () {
            var rows = $("#h-cost-direction-info-table-details").bootstrapTable('getSelections');
            if (rows.length == 0) {
                var direction_id = $("#h-ca-direction-tree-info-list").attr("data-selected");
                if (direction_id == undefined) {
                    $.Notify({
                        message:"请选择需要编辑的成本类别参数",
                        type:"info",
                    });
                    return
                }
                rows.push($("#h-cost-direction-info-table-details").bootstrapTable('getRowByUniqueId',direction_id))
            } else if (rows.length > 1) {
                $.Notify({
                    message:"只能选择<span style='font-weight: 600; color: red;'> 一项 </span>进行编辑",
                    type:"warning",
                });
                return
            };

            $.Hmodal({
                body:$("#h-ca-cost-direction-add-tmpl").html(),
                width:"420px",
                header:"编辑成本类别参数",
                preprocess:function () {
                    var code_number = rows[0].code_number;
                    var direction_desc = rows[0].direction_desc;
                    var direction_up_id = rows[0].direction_up_id;
                    var domain_id = rows[0].domain_id;
                    var direction_attr = rows[0].direction_attr;
                    $("#h-ca-cost-direction-add-form").find("input[name='direction_id']").val(code_number).attr("readonly","readonly");
                    $("#h-ca-cost-direction-add-form").find("input[name='direction_desc']").val(direction_desc);
                    $("#h-ca-cost-direction-add-form").find("input[name='domain_id']").val(domain_id);
                    $("#h-ca-direction-add-attr").Hselect({
                        height:"30px",
                        value:direction_attr,
                        disabled:true,
                    });

                    // 获取域中的所有节点层面费用方向
                    $.getJSON("/v1/ca/cost/direction/nodes",{domain_id:domain_id},function (data) {
                        var arr = new Array()

                        $(data).each(function (index, element) {
                            var e = {}
                            e.id = element.direction_id;
                            e.text = element.direction_desc;
                            e.upId = element.direction_up_id;
                            arr.push(e)
                        });

                        var e = {}
                        e.id = "-1";
                        e.text = "系统树形根结点";
                        e.upId = "##hzwy23##";
                        arr.push(e);

                        $("#h-ca-direction-add-up-id").Hselect({
                            height:"30px",
                            data:arr,
                            value:direction_up_id,
                        })
                    })
                },
                callback:function (hmode) {
                    $.HAjaxRequest({
                        url:"/v1/ca/cost/direction/put",
                        type:"PUT",
                        data:$("#h-ca-cost-direction-add-form").serialize(),
                        success:function () {
                            $.Notify({
                                message:"更新成本类别参数成功",
                                type:"success",
                            });
                            $(hmode).remove();
                            CaDirectionObj.tree(rows[0].domain_id);
                            $("#h-ca-direction-tree-info-list").removeAttr("data-selected")
                        },
                    })
                }
            })
        },
        formatterattr:function (value) {
        if (value == "1"){
            return "节点"
        } else if (value == "0") {
            return "叶子"
        } else {
            return "-"
        }
    },
    formatterUpId:function (value,rows) {
        var tmp = value.split("_join_")
        if (tmp.length == 2){
            return tmp[1]
        } else {
            return value
        }
    },
    tree : function (domain_id) {

        // 获取域中的费用方向信息
        $.getJSON("/v1/ca/cost/direction/get",{domain_id:domain_id},function (data) {

            var arr = new Array();
            $(data).each(function (index, element) {
                var e = {};
                e.id = element.direction_id;
                e.text = element.direction_desc;
                e.upId = element.direction_up_id;
                e.attr = element.direction_attr;
                arr.push(e);
            });

            $("#h-ca-direction-tree-info-list").Htree({
                    data:arr,
                    attr:true,
                    onChange:function (obj) {
                        var id = $(obj).attr("data-id");
                        $("#h-cost-direction-info-table-details tbody tr").each(function (index, element) {
                            if ( $(element).attr("data-uniqueid") == id ) {
                                $(element).addClass("info")
                            } else {
                                $(element).removeClass("info")
                            }
                        })
                    },
                });
                $("#h-cost-direction-info-table-details").bootstrapTable('load',data);
            })
        },
    };

    $(document).ready(function () {
        $("#h-cost-direction-content").height(document.documentElement.clientHeight-130);
        $("#h-ca-direction-tree-info").height(document.documentElement.clientHeight-139);
        $("#h-ca-direction-tree-info-list").height(document.documentElement.clientHeight-211);

        $("#h-cost-direction-info-table-details").bootstrapTable({
            height:document.documentElement.clientHeight-130,
        });

        Hutils.InitDomain({
            height:"24px",
            width:"180px",
            id:"#h-cost-direction-domain-list",
            onclick:function () {
                var domain_id = $("#h-cost-direction-domain-list").val();
                CaDirectionObj.tree(domain_id);
            },
            callback:function (domainId) {
                CaDirectionObj.tree(domainId);
            }
        });
    })
</script>

<script id="h-ca-cost-direction-add-tmpl" type="text/html">
    <form class="row" id="h-ca-cost-direction-add-form">
        <div class="col-sm-12">
            <span>成本类别编码</span>
            <input name="direction_id" placeholder="由1-30位字母,数字组成（必填）" type="text" class="form-control" style="height: 30px; line-height: 30px;">
        </div>
        <div class="col-sm-12" style="margin-top: 15px;">
            <span>成本类别名称</span>
            <input name="direction_desc" placeholder="成本类别详细描述信息（必填）" type="text" class="form-control" style="height: 30px; line-height: 30px;">
        </div>
        <div class="col-sm-12" style="margin-top: 15px;">
            <span>上级成本类别</span>
            <select id="h-ca-direction-add-up-id" name="direction_up_id" type="text" class="form-control" style="height: 30px; line-height: 30px;">
            </select>
        </div>
        <div class="col-sm-12" style="margin-top: 15px;">
            <span>层级属性</span>
            <select id="h-ca-direction-add-attr" name="direction_attr" type="text" class="form-control" style="height: 30px; line-height: 30px;">
                <option value="0">叶子</option>
                <option value="1">结点</option>
            </select>
        </div>
        <div class="col-sm-12" style="display: none">
            <input name="domain_id" type="text" class="form-control">
        </div>
    </form>
</script>
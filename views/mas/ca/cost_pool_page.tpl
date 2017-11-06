<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">成本池配置管理</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-left" style="height: 44px; line-height: 44px; width: 260px;">
        <span style="font-size:10px; font-weight: 600; height: 30px; line-height: 30px; margin-top: 7px;display: inline" class="pull-left">&nbsp;&nbsp;所属域：</span>
        <select id="h-ca-cost-pool-domain-list" class="form-control pull-left" style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
        </select>
    </div>
    <div class="pull-right">
        &nbsp;
        {{if checkResIDAuth "2" "0201060200"}}
        <button onclick="CaCostPoolObj.add()" class="btn btn-info btn-sm" title="新增机构信息">
            <i class="icon-plus"> 新增</i>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0201060600"}}
        <button onclick="CaCostPoolObj.upload()" class="btn btn-info btn-sm" title="导入机构信息">
            <span class="icon-edit"> 导入</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0201060500"}}
        <button onclick="CaCostPoolObj.download()" class="btn btn-info btn-sm" title="导出机构信息">
            <span class="icon-trash"> 导出</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0201060300"}}
        <button onclick="CaCostPoolObj.edit()" class="btn btn-info btn-sm" title="编辑机构信息">
            <span class="icon-edit"> 编辑</span>
        </button>
        {{end}}
        {{if checkResIDAuth "2" "0201060400"}}
        <button onclick="CaCostPoolObj.delete()" class="btn btn-danger btn-sm" title="删除机构信息">
            <span class="icon-trash"> 删除</span>
        </button>
        {{end}}
    </div>
</div>
<div class="subsystem-content" style="padding-top: 3px;">
	<div class="row">
	    <div class="col-sm-12 col-md-5 col-md-4">
	        <div id="h-ca-cost-pool-tree-info" class="thumbnail">
	            <div class="col-ms-12 col-md-12 col-lg-12">
	                <div style="border-bottom: #598f56 solid 1px;height: 44px; line-height: 44px;">
	                    <div class="pull-left">
	                        <span><i class="icon-sitemap"> </i>成本池树形结构</span>
	                    </div>
	                    <div class="pull-right">
	                    <span>
	                        <i class=" icon-search" style="margin-top: 15px;"></i>&nbsp;
	                    </span>
	                    </div>
	                </div>
	            </div>
	            <div id="h-ca-cost-pool-tree-info-list" class="col-sm-12 col-md-12 col-lg-12"
	                 style="padding:15px 5px;overflow: auto">
	            </div>
	        </div>
	    </div>
	    <div class="col-sm-12 col-md-7 col-lg-8" style="padding-left: 0px;">
	        <div id="h-ca-cost-pool-table-info">
	            <table id="h-ca-cost-pool-info-table-details"
	                   data-toggle="table"
	                   data-striped="true"
	                   data-unique-id="cost_id"
                       data-click-to-select="true"
	                   data-side-pagination="client"
	                   data-pagination="true"
	                   data-page-size="50"
	                   data-page-list="[50, 100, 200]"
	                   data-search="false">
	                <thead>
	                <tr>
	                    <th data-field="state" data-checkbox="true"></th>
	                    <th data-sortable="true" data-field="code_number">成本编码</th>
	                    <th data-sortable="true" data-field="cost_desc">成本名称</th>
	                    <th data-sortable="true" data-field="cost_up_id" data-formatter="CaCostPoolObj.upCostId">上级编码</th>
	                    <th data-sortable="true" data-field="gl_account_id" data-formatter="CaCostPoolObj.AccountFormatter">映射科目</th>
	                    <th data-sortable="true" data-align="center" data-field="cost_attr_desc">层级属性</th>
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

    var CaCostPoolObj = {
        $table:$('#h-ca-cost-pool-info-table-details'),
        download:function () {
            var domain_id = $("#h-ca-cost-pool-domain-list").val();
            $.Hdownload({
                url:"/v1/ca/cost/download?domain_id="+domain_id,
                name:"成本池配置信息",
            })
        },
        upload:function () {
            $.Hupload({
                header:"导入成本池信息",
                url:"/v1/ca/cost/upload",
                callback:function () {
                    CaCostPoolObj.tree();
                },
            })
        },
        add:function(){
            $.Hmodal({
                body:$("#h-ca-cost-pool-src").html(),
                width:"420px",
                header:"新增成本项",
                callback:function(hmode){
                    $.HAjaxRequest({
                        url:"/v1/ca/cost/post",
                        type:"post",
                        data:$("#h-ca-cost-pool-form").serialize(),
                        success:function () {
                            $.Notify({
                                message:"新增成本项信息成功",
                                type:"success",
                            });
                            CaCostPoolObj.tree();
                            $(hmode).remove();
                            $("#h-ca-cost-pool-tree-info-list").removeAttr("data-selected")
                        },
                    })
                },
                preprocess:function(){
                    $("#h-ca-cost-pool-form").find("select[name='cost_attr']").Hselect({
                        height:"30px",
                        value:1,
                    });
                    var domain_id = $("#h-ca-cost-pool-domain-list").val();
                    $("#h-ca-cost-pool-form").find("input[name='domain_id']").val(domain_id);

                    $.getJSON("/v1/ca/cost/nodes/get",{domain_id:domain_id},function (data) {
                        var arr = new Array()
                        $(data).each(function (index, element) {
                            var e = {};
                            e.id = element.cost_id;
                            e.text = element.cost_desc;
                            e.upId = element.cost_up_id;
                            arr.push(e)
                        });

                        var e = {};
                        e.id = "-1";
                        e.text = "系统默认根节点";
                        e.upId = "##hzwy23##";
                        arr.push(e)

                        $("#h-ca-cost-pool-form").find("select[name='cost_up_id']").Hselect({
                            height:"30px",
                            data:arr,
                        })
                    })
                    $.getJSON("/v1/common/glaccount/get",{domain_id:domain_id},function (data) {
                        var arr = new Array()
                        $(data).each(function (index, element) {
                            var e = {};
                            e.id = element.gl_account_id;
                            e.text = element.gl_account_desc;
                            e.upId = element.gl_account_up_id;
                            arr.push(e)
                        });

                        var e = {};
                        e.id = "-1";
                        e.text = "系统默认根节点";
                        e.upId = "##hzwy23##";
                        arr.push(e)

                        $("#h-ca-cost-pool-form").find("select[name='gl_account_id']").Hselect({
                            height:"30px",
                            data:arr,
                        })
                    })
                }
            })
        },
        edit:function(){

            var row = CaCostPoolObj.$table.bootstrapTable("getSelections")

            if (row.length == 0){
                var selected_id = $("#h-ca-cost-pool-tree-info-list").attr("data-selected")
                if (selected_id == undefined) {
                    $.Notify({
                        message:"请在列表中选择一个需要编辑的成本项",
                        type:"warning",
                    });
                    return
                }
                row.push($("#h-ca-cost-pool-info-table-details").bootstrapTable('getRowByUniqueId',selected_id))
            } else if (row.length > 1){
                $.Notify({
                    message:"您在列表中选中了多个成本项，不知道需要编辑哪一个",
                    type:"warning",
                })
                return
            };

            var domain_id = row[0].domain_id;
            $.Hmodal({
                body:$("#h-ca-cost-pool-src").html(),
                header:"修改成本项",
                width:"420px",
                preprocess:function () {

                    $("#h-ca-cost-pool-form").find("select[name='cost_attr']").Hselect({
                        height:"30px",
                        value:row[0].cost_attr,
                        disabled:true,
                    });

                    $("#h-ca-cost-pool-form").find("input[name='domain_id']").val(row[0].domain_id);

                    $.getJSON("/v1/ca/cost/nodes/get",{domain_id:row[0].domain_id},function (data) {
                        var arr = new Array()
                        $(data).each(function (index, element) {
                            var e = {};
                            e.id = element.cost_id;
                            e.text = element.cost_desc;
                            e.upId = element.cost_up_id;
                            arr.push(e)
                        });

                        var e = {};
                        e.id = "-1";
                        e.text = "系统默认根节点";
                        e.upId = "##hzwy23##";
                        arr.push(e)

                        $("#h-ca-cost-pool-form").find("select[name='cost_up_id']").Hselect({
                            height:"30px",
                            data:arr,
                            value:row[0].cost_up_id,
                        })
                    });
                    $.getJSON("/v1/common/glaccount/get",{domain_id:row[0].domain_id},function (data) {
                        var arr = new Array()
                        $(data).each(function (index, element) {
                            var e = {};
                            e.id = element.gl_account_id;
                            e.text = element.gl_account_desc;
                            e.upId = element.gl_account_up_id;
                            arr.push(e)
                        });

                        var e = {};
                        e.id = "-1";
                        e.text = "系统默认根节点";
                        e.upId = "##hzwy23##";
                        arr.push(e)

                        $("#h-ca-cost-pool-form").find("select[name='gl_account_id']").Hselect({
                            height:"30px",
                            data:arr,
                            value:row[0].gl_account_id,
                        })
                    })

                    $("#h-ca-cost-pool-form").find("input[name='cost_id']").val(row[0].code_number).attr("readonly","readonly")
                    $("#h-ca-cost-pool-form").find("input[name='cost_desc']").val(row[0].cost_desc)

                },
                callback:function(hmode){
                    $.HAjaxRequest({
                        url: "/v1/ca/cost/put",
                        type: "put",
                        data: $("#h-ca-cost-pool-form").serialize(),
                        success:function (data) {
                            $.Notify({
                                message:"修改成本项信息成功",
                                type:"success",
                            });
                            $(hmode).remove();
                            CaCostPoolObj.tree(domain_id)
                        },
                    })
                }
            })
        },
        delete:function(){

            var rows = CaCostPoolObj.$table.bootstrapTable("getSelections")

            if (rows.length == 0){
                var selected_id = $("#h-ca-cost-pool-tree-info-list").attr("data-selected")
                if (selected_id == undefined) {
                    $.Notify({
                        message:"请在下表中选择需要删除的成本项",
                        type:"warning",
                    });
                    return
                }
                rows.push($("#h-ca-cost-pool-info-table-details").bootstrapTable('getRowByUniqueId',selected_id))
            };

            $.Hconfirm({
                callback:function () {
                    $.HAjaxRequest({
                        url:"/v1/ca/cost/delete",
                        type:"post",
                        data:{JSON:JSON.stringify(rows)},
                        success:function () {
                            $.Notify({
                                message:"删除成本项信息成功",
                                type:"success",
                            });
                            CaCostPoolObj.tree()
                            $("#h-ca-cost-pool-tree-info-list").removeAttr("data-selected")
                        },
                    })
                },
                body:"点击确认,删除选中的成本项信息<br/>删除后无法恢复"
            })

        },
        tree:function(domain_id){
            if (domain_id == undefined){
                domain_id = $("#h-ca-cost-pool-domain-list").val();
            }

            $.getJSON("/v1/ca/cost/get",{
                domain_id:domain_id
            },function(data){
                if (data == null || data.length==0){
                    CaCostPoolObj.$table.bootstrapTable('load',[])
                    $("#h-ca-cost-pool-tree-info-list").Htree({
                        data:[],
                    })
                } else {
                    var arr = new Array()
                    $(data).each(function(index,element){
                        var ijs = {}
                        ijs.id = element.cost_id;
                        ijs.text = element.cost_desc;
                        ijs.upId = element.cost_up_id;
                        ijs.attr = element.cost_attr;
                        arr.push(ijs)
                    });

                    $("#h-ca-cost-pool-tree-info-list").Htree({
                        data:arr,
                        attr:true,
                        onChange:function(obj){
                            var cost_id = $(obj).attr("data-id");
                            var domain_id = $("#h-ca-cost-pool-domain-list").val();
                            $.getJSON("/v1/ca/cost/sub/get",{domain_id:domain_id,cost_id:cost_id},function(data){
                                CaCostPoolObj.$table.bootstrapTable('load',data)
                                $("#h-ca-cost-pool-info-table-details tbody tr").each(function (index, element) {
                                    if ( $(element).attr("data-uniqueid") == cost_id ) {
                                        $(element).addClass("info")
                                    }
                                })
                            });
                        }
                    });
                    CaCostPoolObj.$table.bootstrapTable('load',data)
                }
            })
        },
        upCostId:function(value,row,index){
            var upcombine = row.cost_up_id.split("_join_")
            if (upcombine.length==2){
                return upcombine[1]
            }else{
                return upcombine
            }
        },
        AccountFormatter:function(value,row,index){
            var upcombine = row.gl_account_id.split("_join_")
            if (upcombine.length==2){
                return upcombine[1]
            }else{
                return upcombine
            }
        },
    };

    $(document).ready(function(){
        var hwindow = document.documentElement.clientHeight;
        $("#h-ca-cost-pool-tree-info").height(hwindow-153);
        $("#h-ca-cost-pool-table-info").height(hwindow-140);
        $("#h-ca-cost-pool-tree-info-list").height(hwindow-224);

        $('#h-ca-cost-pool-info-table-details').bootstrapTable({
            height:hwindow-140,
        });

        Hutils.InitDomain({
            id:"#h-ca-cost-pool-domain-list",
            height:"24px",
            width:"180px",
            onclick:function () {
                var id = $("#h-ca-cost-pool-domain-list").val();
                CaCostPoolObj.tree(id);
            },
            callback:function (domainId) {
                CaCostPoolObj.tree(domainId);
            },
        });
    });
</script>
<script id="h-ca-cost-pool-src" type="text/html">
    <form class="row" id="h-ca-cost-pool-form">
        <div class="col-sm-12">
            <span>成本项编码</span>
            <input name="cost_id" placeholder="由1-30位字母,数字组成（必填）" style="height: 30px; line-height: 30px;" class="form-control"/>
        </div>
        <div class="col-sm-12" style="margin-top: 12px;">
            <span>成本项名称</span>
            <input name="cost_desc" placeholder="成本项的详细描述信息（必填）" style="height: 30px; line-height: 30px;" class="form-control"/>
        </div>
        <div class="col-sm-12" style="margin-top: 12px;">
            <span>上级成本项</span>
            <select name="cost_up_id" style="width:100%;height: 30px; line-height: 30px;" class="form-control">
            </select>
        </div>
        <div class="col-sm-12" style="margin-top: 12px;">
            <span>映射科目</span>
            <select name="gl_account_id" style="width:100%;height: 30px; line-height: 30px;" class="form-control">
            </select>
        </div>
        <div class="col-sm-12" style="margin-top: 12px;">
            <span>结点/叶子标识</span>
            <select name="cost_attr" style="width:100%;height: 30px; line-height: 30px;" class="form-control">
                <option value="0">叶子</option>
                <option value="1">结点</option>
            </select>
        </div>
        <div class="col-sm-12" style="margin-top: 12px;display: none;">
            <span>所属域</span>
            <input name="domain_id"/>
        </div>
    </form>
</script>
<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">科目配置管理</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-left" style="height: 44px; line-height: 44px; width: 260px;">
        <span style="font-size: 10px; font-weight: 600; height: 30px; line-height: 30px; margin-top: 7px;display: inline" class="pull-left">&nbsp;&nbsp;所属域：</span>
        <select id="h-common-account-domain-list" class="form-control pull-left" style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
        </select>
    </div>
    <div class="pull-right">
        <button onclick="CaGlAccountObj.add()" class="btn btn-info btn-sm" title="新增机构信息">
            <i class="icon-plus"> 新增</i>
        </button>
        <button onclick="CaGlAccountObj.upload()" class="btn btn-info btn-sm" title="导入机构信息">
            <span class="icon-edit"> 导入</span>
        </button>
        <button onclick="CaGlAccountObj.download()" class="btn btn-info btn-sm" title="导出机构信息">
            <span class="icon-trash"> 导出</span>
        </button>
        <button onclick="CaGlAccountObj.edit()" class="btn btn-info btn-sm" title="编辑机构信息">
            <span class="icon-edit"> 编辑</span>
        </button>
        <button onclick="CaGlAccountObj.delete()" class="btn btn-danger btn-sm" title="删除机构信息">
            <span class="icon-trash"> 删除</span>
        </button>
    </div>
</div>
<div class="subsystem-content" style="padding-top: 1px;">
    <div class="row">
        <div class="col-sm-12 col-md-5 col-md-5">
            <div id="h-common-accounting-tree-info" class="thumbnail">
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
                <div id="h-common-accounting-tree-info-list" class="col-sm-12 col-md-12 col-lg-12"
                     style="padding:15px 5px;overflow: auto">
                </div>
            </div>
        </div>
        <div id="h-common-accounting-table-info" class="col-sm-12 col-md-7 col-lg-7" style="padding-left: 0px;">
            <table id="h-common-accounting-table-id"
                   data-toggle="table"
                   data-unique-id="gl_account_id"
                   data-side-pagination="client"
                   data-pagination="true"
                   data-click-to-select="true"
                   data-page-size="30"
                   data-page-list="[10, 20, 30, 50, 100, 200]"
                   data-search="false">
                <thead>
                <tr>
                    <th data-field="state" data-checkbox="true"></th>
                    <th data-sortable="true" data-field="code_number">科目编码</th>
                    <th data-sortable="true" data-field="gl_account_desc">科目名称</th>
                    <th data-sortable="true" data-field="gl_account_up_id" data-formatter="CaGlAccountObj.AccountFormatter">上级编码</th>
                    <th data-sortable="true" data-field="gl_level">层级</th>
                    <th data-sortable="true" data-align="center" data-field="modify_date">修改日期</th>
                    <th data-sortable="true" data-align="center" data-field="modify_user">修改人</th>
                </tr>
                </thead>
            </table>
        </div>
    </div>
</div>

<script type="text/javascript">

    var CaGlAccountObj = {
        $table:$('#h-common-accounting-table-id'),
        download:function () {
            var domain_id = $("#h-common-account-domain-list").val();
            $.Hdownload({
                url:"/v1/common/glaccount/download?domain_id="+domain_id,
                name:"科目配置信息",
            })
        },
        upload:function () {
            $.Hupload({
                header:"上传科目参数信息",
                url:"/v1/common/glaccount/upload",
                callback:function () {
                    CaGlAccountObj.tree();
                },
            })
        },
        add:function(){
            $.Hmodal({
                body:$("#h-common-accounting-src").html(),
                width:"420px",
                header:"新增科目信息",
                callback:function(hmode){
                    $.HAjaxRequest({
                        url:"/v1/common/glaccount/post",
                        type:"post",
                        data:$("#h-common-accounting-form").serialize(),
                        success:function () {
                            $.Notify({
                                message:"新增科目信息成功",
                                type:"success",
                            });
                            CaGlAccountObj.tree();
                            $(hmode).remove();
                        },
                    })
                },
                preprocess:function(){
                    $("#h-common-accounting-form").find("select[name='gl_level']").Hselect({
                        height:"30px",
                        value:1,
                    });
                    var domain_id = $("#h-common-account-domain-list").val();
                    $("#h-common-accounting-form").find("input[name='domain_id']").val(domain_id);

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

                        $("#h-common-accounting-form").find("select[name='gl_account_up_id']").Hselect({
                            height:"30px",
                            data:arr,
                        })
                    })
                }
            })
        },
        edit:function(){
            var row = CaGlAccountObj.$table.bootstrapTable("getSelections")
            if (row.length == 0){
                var selected_id = $("#h-common-accounting-tree-info-list").attr("data-selected")
                if (selected_id == undefined) {
                    $.Notify({
                        title:"温馨提示",
                        message:"请在列表中选择一项需要编辑的科目",
                        type:"info",
                    });
                    return
                }
                row.push($("#h-common-accounting-table-id").bootstrapTable('getRowByUniqueId',selected_id))
            } else if (row.length > 1){
                $.Notify({
                    title:"温馨提示",
                    message:"只能对<span style='color: red; font-weight: 600;'>一项</span>进行编辑",
                    type:"info",
                });
                return
            };

            var domain_id = row[0].domain_id;
            $.Hmodal({
                body:$("#h-common-accounting-src").html(),
                header:"编辑科目信息",
                width:"420px",
                preprocess:function () {

                    $("#h-common-accounting-form").find("select[name='gl_level']").Hselect({
                        height:"30px",
                        value:row[0].gl_level,
                    });

                    $("#h-common-accounting-form").find("input[name='domain_id']").val(row[0].domain_id);

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

                        $("#h-common-accounting-form").find("select[name='gl_account_up_id']").Hselect({
                            height:"30px",
                            data:arr,
                            value:row[0].gl_account_up_id,
                        })
                    })

                    $("#h-common-accounting-form").find("input[name='gl_account_id']").val(row[0].code_number).attr("readonly","readonly")
                    $("#h-common-accounting-form").find("input[name='gl_account_desc']").val(row[0].gl_account_desc)

                },
                callback:function(hmode){
                    $.HAjaxRequest({
                        url: "/v1/common/glaccount/put",
                        type: "put",
                        data: $("#h-common-accounting-form").serialize(),
                        success:function (data) {
                            $.Notify({
                                title:"温馨提示：",
                                message:"修改科目信息成功",
                                type:"success",
                            });
                            $(hmode).remove();
                            CaGlAccountObj.tree(domain_id)
                            $("#h-common-accounting-tree-info-list").removeAttr("data-selected");
                        },
                    })
                }
            })
        },
        getSubOrg:function(set,all){

            var addArray = new Array();

            var search = function(obj,arr){
                $(arr).each(function(index,element){
                    if (obj.org_id == element.up_org_id){
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
        delete:function(){

            var rows = CaGlAccountObj.$table.bootstrapTable("getSelections");

            if (rows.length == 0){
                var selected_id = $("#h-common-accounting-tree-info-list").attr("data-selected")
                if (selected_id == undefined) {
                    $.Notify({
                        title:"温馨提示",
                        message:"您没有列表中选择需要删除的科目",
                        type:"warning",
                    })
                    return
                }
                rows.push($("#h-common-accounting-table-id").bootstrapTable('getRowByUniqueId',selected_id))
            };

            $.Hconfirm({
                callback:function () {
                    $.HAjaxRequest({
                        url:"/v1/common/glaccount/delete",
                        type:"post",
                        data:{JSON:JSON.stringify(rows)},
                        success:function () {
                            $.Notify({
                                title:"操作成功",
                                message:"删除科目信息成功",
                                type:"success",
                            });
                            CaGlAccountObj.tree()
                            $("#h-common-accounting-tree-info-list").removeAttr("data-selected");
                        },
                    })
                },
                body:"点击确认删除选中的科目<br/>这个科目的下级科目也会一同删除"
            })

        },
        tree:function(domain_id){
            if (domain_id == undefined){
                domain_id = $("#h-common-account-domain-list").val()
            }
            $.getJSON("/v1/common/glaccount/get",{domain_id:domain_id},function(data){
                if (data.length==0){
                    $.Notify({
                        title:"温馨提示",
                        message:"您选择的域中没有配置科目信息",
                        type:"info",
                    });
                    CaGlAccountObj.$table.bootstrapTable('load',[]);
                    $("#h-common-accounting-tree-info-list").HtreeWithLine({
                        data:[],
                    });
                } else {
                    var arr = new Array();
                    $(data).each(function(index,element){
                        var ijs = {};
                        ijs.id = element.gl_account_id;
                        ijs.text = element.gl_account_desc;
                        ijs.upId = element.gl_account_up_id;
                        arr.push(ijs)
                    });

                    $("#h-common-accounting-tree-info-list").HtreeWithLine({
                        data:arr,
                        onChange:function(obj){
                            var id = $(obj).attr("data-id")
                            var domain_id = $("#h-common-account-domain-list").val()
                            $.getJSON("/v1/common/glaccount/sub/get",{domain_id:domain_id,gl_account_id:id},function (data) {
                                CaGlAccountObj.$table.bootstrapTable('load',data)
                                $("#h-common-accounting-table-id tbody tr").each(function (index, element) {
                                    if ( $(element).attr("data-uniqueid") == id ) {
                                        $(element).addClass("info")
                                    }
                                })
                            })
                        }
                    });
                    CaGlAccountObj.$table.bootstrapTable('load',data)
                }
            })
        },
        AccountFormatter:function(value,row,index){
            var upcombine = row.gl_account_up_id.split("_join_")
            if (upcombine.length==2){
                return upcombine[1]
            }else{
                return upcombine
            }
        },
    };

    $(document).ready(function(){
        var hwindow = document.documentElement.clientHeight;
        $("#h-common-accounting-tree-info").height(hwindow-139);
        $("#h-common-accounting-table-info").height(hwindow-130);
        $("#h-common-accounting-tree-info-list").height(hwindow-214);

        $('#h-common-accounting-table-id').bootstrapTable({
            height:hwindow-130,
        });

        Hutils.InitDomain({
            id:"#h-common-account-domain-list",
            height:"24px",
            width:"180px",
            onclick:function () {
                var id = $("#h-common-account-domain-list").val();
                CaGlAccountObj.tree(id);
            },
            callback:function (domainId) {
                CaGlAccountObj.tree(domainId);
            }
        });
    });
</script>
<script id="h-common-accounting-src" type="text/html">
    <form class="row" id="h-common-accounting-form">
        <div class="col-sm-12">
            <span>科目编码</span>
            <input name="gl_account_id" placeholder="由1-30位字母,数字组成" style="height: 30px; line-height: 30px;" class="form-control"/>
        </div>
        <div class="col-sm-12" style="margin-top: 12px;">
            <span>科目名称</span>
            <input name="gl_account_desc" placeholder="科目详细描述信息" style="height: 30px; line-height: 30px;" class="form-control"/>
        </div>
        <div class="col-sm-12" style="margin-top: 12px;">
            <span>上级成本编码</span>
            <select name="gl_account_up_id" style="width:100%;height: 30px; line-height: 30px;" class="form-control">
            </select>
        </div>
        <div class="col-sm-12" style="margin-top: 12px;">
            <span>科目层级</span>
            <select name="gl_level" style="width:100%;height: 30px; line-height: 30px;" class="form-control">
                <option value="1">一级科目</option>
                <option value="2">二级科目</option>
                <option value="3">三级科目</option>
                <option value="4">四级科目</option>
                <option value="5">五级科目</option>
                <option value="6">六级科目</option>
                <option value="7">七级科目</option>
            </select>
        </div>
        <div class="col-sm-12" style="margin-top: 20px;display: none;">
            <span>所属域</span>
            <input name="domain_id"/>
        </div>
    </form>
</script>
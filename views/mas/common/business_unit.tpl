<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">事业部/条线配置管理</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-left" style="height: 44px; line-height: 44px; width: 260px;">
        <span style="font-size: 10px; font-weight: 600; height: 30px; line-height: 30px; margin-top: 7px;display: inline" class="pull-left">&nbsp;&nbsp;所属域：</span>
        <select id="h-common-business-domain-list" class="form-control pull-left" style="width: 180px;height: 24px; line-height: 24px; margin-top: 10px;padding: 0px;">
        </select>
    </div>
    <div class="pull-right">
        <button onclick="CommonBUObj.add()" class="btn btn-info btn-sm" title="新增机构信息">
            <i class="icon-plus"> 新增</i>
        </button>
        <button onclick="CommonBUObj.upload()" class="btn btn-info btn-sm" title="导入机构信息">
            <span class="icon-edit"> 导入</span>
        </button>
        <button onclick="CommonBUObj.download()" class="btn btn-info btn-sm" title="导出机构信息">
            <span class="icon-trash"> 导出</span>
        </button>
        <button onclick="CommonBUObj.update()" class="btn btn-info btn-sm" title="编辑机构信息">
            <span class="icon-edit"> 编辑</span>
        </button>
        <button onclick="CommonBUObj.delete()" class="btn btn-danger btn-sm" title="删除机构信息">
            <span class="icon-trash"> 删除</span>
        </button>
    </div>
</div>
<div class="subsystem-content" style="padding-top: 3px;">
    <div class="row">
        <div class="col-sm-12 col-md-5 col-lg-3">
            <div id="h-common-business-tree-info" class="thumbnail">
                <div class="col-ms-12 col-md-12 col-lg-12">
                    <div style="border-bottom: #598f56 solid 1px;height: 44px; line-height: 44px;">
                        <div class="pull-left">
                            <span><i class="icon-sitemap"> </i>事业部/条线树形图</span>
                        </div>
                        <div class="pull-right">
                    <span>
                        <i class="icon-search" style="margin-top: 15px;"></i>&nbsp;
                    </span>
                        </div>
                    </div>
                </div>
                <div id="h-common-business-tree-info-list" class="col-sm-12 col-md-12 col-lg-12"
                     style="padding:15px 5px;overflow: auto">
                </div>
            </div>
        </div>
        <div id="h-common-business-content" class="col-sm-12 col-md-7 col-lg-9" style="padding-left: 0px;">
            <table id="h-common-business-table-id"
                   data-toggle="table"
                   data-striped="true"
                   data-click-to-select="true"
                   data-unique-id="business_unit_id"
                   data-side-pagination="client"
                   data-pagination="false"
                   data-search="false">
                <thead>
                <tr>
                    <th data-field="state" data-checkbox="true"></th>
                    <th data-sortable="true" data-field="code_number">条线编码</th>
                    <th data-sortable="true" data-field="business_unit_desc">条线名称</th>
                    <th data-sortable="true" data-field="business_unit_up_id" data-formatter="CommonBUObj.formatterUpId">上级编码</th>
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
<script type="text/javascript">

    var CommonBUObj = {
        download:function () {
            var domain_id = $("#h-common-business-domain-list").val()
            var url = "/v1/common/depart/download?domain_id="+domain_id;
            $.Hdownload({
                url:url,
                name:"条线参数信息",
            })
        },
        upload:function () {
            $.Hupload({
                header:"上传条线参数信息",
                url:"/v1/common/depart/upload",
                callback:function() {
                    var domain_id = $("#h-common-business-domain-list").val();
                    CommonBUObj.tree(domain_id)
                    $("#h-common-business-tree-info-list").removeAttr("data-selected")
                }
            })
        },
        add:function () {
          $.Hmodal({
              header:"新增条线信息",
              body:$("#h-common-business-src").html(),
              width:"420px",
              callback:function (hmode) {
                  $.HAjaxRequest({
                      url:"/v1/common/depart/post",
                      type:"post",
                      data:$("#h-common-business-form").serialize(),
                      success:function () {
                          $.Notify({
                              message:"新增条线信息成功",
                              type:"success",
                          });
                          var domain_id = $("#h-common-business-domain-list").val();
                          CommonBUObj.tree(domain_id)
                          $(hmode).remove()
                      }
                  })
              },
              preprocess:function () {

                  $("#h-ca-direction-add-attr").Hselect({
                      height:"30px",
                  });
                  var direction_id = $("#h-common-business-tree-info-list").attr("data-selected");

                  var domain_id = $("#h-common-business-domain-list").val();

                  $("#h-common-business-form").find("input[name='domain_id']").val(domain_id)

                  // 获取域中的所有节点层面费用方向
                  $.getJSON("/v1/common/depart/get",{domain_id:domain_id},function (data) {
                      var arr = new Array()

                      $(data).each(function (index, element) {
                          var e = {}
                          e.id = element.business_unit_id;
                          e.text = element.business_unit_desc;
                          e.upId = element.business_unit_up_id;
                          arr.push(e)
                      });

                      var e = {};
                      e.id = "mas_join_-1";
                      e.text = "系统树形根结点";
                      e.upId = "##hzwy23##";
                      arr.push(e);

                      $("#h-common-form-business-up-id").Hselect({
                          height:"30px",
                          data:arr,
                          value:direction_id,
                      })
                  })
              },
          })  
        },
        delete:function () {
            var rows = $("#h-common-business-table-id").bootstrapTable('getSelections');
            if (rows.length == 0) {
                var direction_id = $("#h-common-business-tree-info-list").attr("data-selected");
                if (direction_id == undefined) {
                    $.Notify({
                        message:"请选择需要删除的条线信息",
                        type:"warning",
                    })
                    return
                }
                rows.push($("#h-common-business-table-id").bootstrapTable('getRowByUniqueId',direction_id))
            }

            $.Hconfirm({
                body:"点击确定将会删除选中的条线信息<br/>其下级信息也将会一同删除",
                callback:function () {
                    $.HAjaxRequest({
                        url:"/v1/common/depart/delete",
                        type:"POST",
                        data:{JSON:JSON.stringify(rows)},
                        success:function () {
                            $.Notify({
                                message:"删除条线信息成功",
                                type:"success",
                            });
                            var domain_id = $("#h-common-business-domain-list").val();
                            CommonBUObj.tree(domain_id);
                            $("#h-common-business-tree-info-list").removeAttr("data-selected")
                        },
                    })
                },
            })
        },
        update:function () {
            var rows = $("#h-common-business-table-id").bootstrapTable('getSelections');
            if (rows.length == 0) {
                var direction_id = $("#h-common-business-tree-info-list").attr("data-selected");
                if (direction_id == undefined) {
                    $.Notify({
                        message:"请选择需要编辑的条线信息",
                        type:"warning",
                    });
                    return
                }
                rows.push($("#h-common-business-table-id").bootstrapTable('getRowByUniqueId',direction_id))
            } else if (rows.length > 1) {
                $.Notify({
                    message:"只能选择<span style='font-weight: 600; color: red;'>一项</span>进行编辑",
                    type:"warning",
                });
                return
            };

            var row = rows[0];
            $.Hmodal({
                body:$("#h-common-business-src").html(),
                width:"420px",
                header:"编辑条线信息",
                preprocess:function () {
                    var code_number = row.code_number;
                    var direction_desc = row.business_unit_desc;
                    var direction_up_id = row.business_unit_up_id;
                    var domain_id = row.domain_id;
                    $("#h-common-business-form").find("input[name='business_unit_id']").val(code_number).attr("readonly","readonly");
                    $("#h-common-business-form").find("input[name='business_unit_desc']").val(direction_desc);
                    $("#h-common-business-form").find("input[name='domain_id']").val(domain_id);


                    // 获取域中的所有节点层面费用方向
                    $.getJSON("/v1/common/depart/get",{domain_id:domain_id},function (data) {
                        var arr = new Array()

                        $(data).each(function (index, element) {
                            var e = {};
                            e.id = element.business_unit_id;
                            e.text = element.business_unit_desc;
                            e.upId = element.business_unit_up_id;
                            arr.push(e)
                        });

                        var e = {};
                        e.id = "mas_join_-1";
                        e.text = "系统树形根结点";
                        e.upId = "##hzwy23##";
                        arr.push(e);

                        $("#h-common-form-business-up-id").Hselect({
                            height:"30px",
                            data:arr,
                            value:direction_up_id,
                        })
                    })
                },
                callback:function (hmode) {
                    $.HAjaxRequest({
                        url:"/v1/common/depart/put",
                        type:"PUT",
                        data:$("#h-common-business-form").serialize(),
                        success:function () {
                            $.Notify({
                                message:"更新条线信息成功",
                                type:"success",
                            });
                            $(hmode).remove();
                            CommonBUObj.tree(rows[0].domain_id);
                            $("#h-common-business-tree-info-list").removeAttr("data-selected");
                        },
                    })
                }
            })
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
            $.getJSON("/v1/common/depart/get",{domain_id:domain_id},function (data) {
                var arr = new Array()
                $(data).each(function (index, element) {
                    var e = {};
                    e.id = element.business_unit_id;
                    e.text = element.business_unit_desc;
                    e.upId = element.business_unit_up_id;
                    arr.push(e);
                });
                $("#h-common-business-tree-info-list").HtreeWithLine({
                    data:arr,
                    onChange:function (obj) {
                        var id = $(obj).attr("data-id");
                        $("#h-common-business-table-id tbody tr").each(function (index, element) {
                            if ( $(element).attr("data-uniqueid") == id ) {
                                $(element).addClass("info");
                            } else {
                                $(element).removeClass("info");
                            }
                        })
                    },
                });
                $("#h-common-business-table-id").bootstrapTable('load',data);
            })
        },
    };

    $(document).ready(function () {
        $("#h-common-business-content").height(document.documentElement.clientHeight-130);
        $("#h-common-business-tree-info").height(document.documentElement.clientHeight-139);

        $("#h-common-business-table-id").bootstrapTable({
            height:document.documentElement.clientHeight-130,
        });

        Hutils.InitDomain({
            id:"#h-common-business-domain-list",
            height:"24px",
            width:"180px",
            onclick:function () {
                var domain_id = $("#h-common-business-domain-list").val();
                CommonBUObj.tree(domain_id)
            },
            callback:function (domainId) {
                CommonBUObj.tree(domainId);
            }
        });
    })
</script>

<script id="h-common-business-src" type="text/html">
    <form class="row" id="h-common-business-form">
        <div class="col-sm-12 col-md-12 col-lg-12">
            <span>事业部/条线编码</span>
            <input name="business_unit_id" placeholder="由1-30位字母,数字组成（必填）" type="text" class="form-control" style="height: 30px; line-height: 30px;">
        </div>
        <div class="col-sm-12 col-md-12 col-lg-12" style="margin-top: 15px;">
            <span>事业部/条线名称</span>
            <input name="business_unit_desc" placeholder="条线详细描述信息（必填）" type="text" class="form-control" style="height: 30px; line-height: 30px;">
        </div>
        <div class="col-sm-12 col-md-12 col-lg-12" style="margin-top: 15px;">
            <span>上级事业部/条线</span>
            <select id="h-common-form-business-up-id" name="business_unit_up_id" type="text" class="form-control" style="height: 30px; line-height: 30px;">
            </select>
        </div>
        <div class="col-sm-6 col-md-6 col-lg-6" style="display: none">
            <input name="domain_id" type="text" class="form-control">
        </div>
    </form>
</script>
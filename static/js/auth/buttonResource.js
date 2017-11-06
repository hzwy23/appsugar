/**
 * 研发平台
 * http://www.wisrc.com
 * @Auth:  zhanwei huang
 * E-mail: hzwy23@163.com
 * 功能按钮动态响应代码
 */

var ResFuncObj = {
    formatterOpenType:function (val) {
        if (val == "0") {
            return "内部区域"
        } else {
            return "新选项卡"
        }
    },
    delete:function () {
        var rows = $("#h-resource-button").bootstrapTable('getSelections');
        if (rows.length === 0){
            $.Notify({
                message:"请选择需要删除的服务功能",
                type:"warning",
            });
            return
        }
        $.Hconfirm({
            body:"点击确定删除功能按钮",
            callback:function () {
                $.HAjaxRequest({
                    url:"/v1/auth/resource/func",
                    type:"delete",
                    data:{JSON:JSON.stringify(rows)},
                    success:function () {
                        $.Notify({
                            message:"删除菜单资源成功",
                            type:"success",
                        });
                        var resId = $("#h-resource-list-info").attr("data-selected");
                        ResFuncObj.queryButton(resId);
                    },
                })
            }
        })
    },
    add:function () {
        var resUpId = $("#h-resource-list-info").attr("data-selected");

        if (resUpId == undefined){
            $.Notify({
                message:"请在菜单资源树中选择用于挂在功能服务的菜单页",
                type:"warning",
            });
            return;
        }
        $.Hmodal({
            header:"新增服务资源",
            body:$("#res_input_form").html(),
            width:"420px",
            callback:function (hmode) {
                $.HAjaxRequest({
                    url:"/v1/auth/resource/func",
                    data:$("#h-res-add-info").serialize(),
                    type:"post",
                    success:function () {
                        $.Notify({
                            message:"新增功能按钮成功",
                            type:"success"
                        });
                        $(hmode).remove();
                        ResFuncObj.queryButton(resUpId);
                    }
                })
            },
            preprocess:function () {

                $("#h-res-add-up-res-id").val(resUpId);

                $("#h-res-add-res-type").Hselect({
                    height:"30px",
                    value:"0"
                });

                $("#h-res-add-new-iframe").Hselect({
                    height:"30px",
                    value:"false"
                });

                $("#h-res-add-res-method").Hselect({
                    height:"30px",
                    value:"GET"
                });
            }
        })
    },
    tree:function (resId) {
        if (resId == undefined) {
            resId = "-1";
        }

        $.getJSON("/v1/auth/menu/all/except/button",{
            resId: resId
        },function (data) {
            if (data === null || data.length === 0){
                $.Notify({
                    message:"这个模块中暂时没有配置菜单信息",
                    type:"info",
                });
                $("#h-resource-list-info").Htree({
                    data:[],
                })
            } else {
                var arr = new Array();
                $(data).each(function(index,element){
                    var ijs = {};
                    ijs.id = element.Res_id;
                    ijs.text = element.Res_name;
                    ijs.upId = element.Res_up_id;
                    if (element.Res_attr == "0"){
                        ijs.attr = "1";
                    } else {
                        ijs.attr = "0";
                    }
                    arr.push(ijs)
                });
                $("#h-resource-list-info").HtreeWithLine({
                    data:arr,
                    onChange:function(obj){
                        var id = $(obj).attr("data-id");
                        ResFuncObj.queryButton(id);
                    }
                });
            }
        })
    },
    edit:function(){
        var rows = $("#h-resource-button").bootstrapTable('getSelections');
        if (rows.length !== 1){
            $.Notify({
                message:"请选择<span style='color: red; font-weight: 600;'>一项</span>进行编辑",
                type:"warning"
            });
            return
        }
        var row = rows[0];
        $.Hmodal({
            header:"编辑功能按钮",
            body:$("#res_input_form").html(),
            width:"420px",
            callback:function (hmode) {
                $("#h-res-modify-uuid").val(row.Uuid);
                $.HAjaxRequest({
                    url:"/v1/auth/resource/func",
                    type:"put",
                    data:$("#h-res-add-info").serialize(),
                    success:function () {
                        $.Notify({
                            message:"修改菜单资源名称成功",
                            type:"success"
                        });
                        $(hmode).remove();
                        ResFuncObj.queryButton(row.ResUpId);
                    }
                })
            },
            preprocess:function () {

                $("#h-res-add-res-name").val(row.ResName);
                $("#h-res-add-res-url").val(row.ResUrl);
                $("#h-res-add-res-id").val(row.ResId).attr("readonly","readonly");
                $("#h-res-add-up-res-id").val(row.ResUpId);

                $("#h-res-add-res-type").Hselect({
                    height:"30px",
                    value:row.ResOpenType
                });

                $("#h-res-add-new-iframe").Hselect({
                    height:"30px",
                    value:row.NewIframe
                });
                $("#h-res-add-res-method").Hselect({
                    height:"30px",
                    value:row.Method
                });
            }
        })
    },
    queryButton:function (resId) {
        $.HAjaxRequest({
            url: "/v1/auth/resource/func",
            type: "Get",
            data: {resId:resId},
            success: function (data) {
                $("#h-resource-button").bootstrapTable('load',data);
            }
        });
    }
};

$(document).ready(function() {
    /*
    * 调整属性信息显示框大小
    * 高度填充全屏高度
    * */
    var hwindow = document.documentElement.clientHeight;
    $("#h-resource-tree-info").height(hwindow - 130);
    $("#h-resource-list-info").height(hwindow - 204);
    ResFuncObj.tree();
    $("#h-resource-button").bootstrapTable({
        height:hwindow-130
    });

    $.getJSON("/v1/auth/resource/subsystem",function (data) {
        var arr = new Array();
        $(data).each(function (index, element) {
            var e = {};
            e.id = element.resId;
            e.text = element.resDesc;
            e.upId = element.resUpId;
            arr.push(e);
        });

        var e = {};
        e.id = "-1";
        e.text = "所有模块";
        e.upId = "##hzwy23##";
        arr.push(e);

        $("#h-subsystem-func-list").Hselect({
            data:arr,
            height:"24px",
            value:"-1",
            onclick:function () {
                var resId = $("#h-subsystem-func-list").val();
                ResFuncObj.tree(resId);
            }
        })
    });
    $("#h-resource-theme-list").Hselect({
        height:"24px",
        value:"1001",
        onclick:function () {
            var themeId = $("#h-resource-theme-list").val();
            var resId = $("#h-resource-list-info").attr("data-selected");
            ResFuncObj.queryButton(resId,themeId);
        }
    });
});
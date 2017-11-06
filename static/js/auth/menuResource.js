var ResObj = {
    delete:function () {
        $.Hconfirm({
            body:"点击确定删除菜单资源信息",
            callback:function () {
                $.HAjaxRequest({
                    url:"/v1/auth/resource/delete",
                    type:"post",
                    data:{res_id: $("#h-auth-resource-show-id").html()},
                    success:function () {
                        $.Notify({
                            message:"删除菜单资源成功",
                            type:"success"
                        });
                        var resId = $("#h-auth-menu-subsystem-list").val();
                        ResObj.tree(resId);
                    }
                })
            }
        })
    },
    add:function () {
        $.Hmodal({
            header:"新增资源",
            body:$("#h_auth_res_input_form").html(),
            width:"420px",
            callback:function (hmode) {
                $.HAjaxRequest({
                    url:"/v1/auth/resource/post",
                    data:$("#h-res-add-info").serialize(),
                    type:"post",
                    success:function () {
                        $.Notify({
                            message:"新增菜单资源成功",
                            type:"success"
                        });
                        $(hmode).remove();
                        var resId = $("#h-auth-menu-subsystem-list").val();
                        ResObj.tree(resId);
                    }
                })
            },
            preprocess:function () {
                $("#h-res-add-type-id").Hselect({
                    height: "30px",
                    onclick: function () {
                        var id = $("#h-res-add-type-id").val();
                        ResObj.selectType(id)
                    },
                    value: "0"
                });
                $("#h-res-add-res-method").Hselect({
                    height:"30px",
                    value:"GET"
                });

                $.getJSON("/v1/auth/resource/node",function (data) {
                    var arr = new Array();
                    $(data).each(function (index, element) {
                        var ijs = {};
                        ijs.id = element.resId;
                        ijs.text = element.resName;
                        ijs.upId = element.resUpId;
                        arr.push(ijs);
                    });
                    $("#h-res-add-up-res-id").Hselect({
                        data: arr,
                        height:"30px"
                    })
                });
            }
        })
    },
    selectType:function (type_id) {
        switch (type_id){
            case "0":
                // 主菜单系统
                $("#h-res-add-up-res-id").parent().hide();
                $("#h-res-add-res-method").parent().show();
                break;
            case "1":
                // 子页面系统
                $("#h-res-add-up-res-id").parent().show();
                $("#h-res-add-res-method").parent().show();
                break;
            case "4":
                // 虚拟节点
                $("#h-res-add-up-res-id").parent().show();
                $("#h-res-add-res-method").parent().hide();
                break;
        }
    },
    updateTheme:function () {
        var id = $("#h-auth-resource-show-id").html();
        var theme_id = $("#h-auth-resource-theme-style-code").val();
        $.getJSON("/v1/auth/resource/queryTheme",{
            res_id:id,
            theme_id:theme_id
        },function (e) {
            if (e.length === 0){
                $("#h-auth-resource-show-res-bg-color").html("-");
                $("#h-auth-resource-show-res-class").html("-");
                $("#h-auth-resource-show-res-img").html("-");
                $("#h-auth-resource-show-res-url").html("-");
                $("#h-auth-resource-show-res-group-id").html("-");
                $("#h-auth-resource-show-res-sort-id").html("-");
                $("#h-auth-resource-show-res-res-type").html("-");
                $("#h-auth-resource-show-res-res-type-desc").html("-");
                $("#h-auth-resource-show-res-new-iframe").html("-");
            } else {
                $(e).each(function(index,element){
                    $("#h-auth-resource-show-res-bg-color").html(element.res_bg_color);
                    $("#h-auth-resource-show-res-class").html(element.res_class);
                    $("#h-auth-resource-show-res-img").html(element.res_img);
                    $("#h-auth-resource-show-res-url").html(element.res_url);
                    $("#h-auth-resource-show-res-group-id").html(element.group_id);
                    $("#h-auth-resource-show-res-sort-id").html(element.sort_id);
                    $("#h-auth-resource-show-res-new-iframe").html(element.new_iframe);
                    $("#h-auth-resource-show-res-res-type").html(element.res_open_type);
                    if (element.res_open_type == "0") {
                        $("#h-auth-resource-show-res-res-type-desc").html("内嵌页面")
                    } else if (element.res_open_type == "1") {
                        $("#h-auth-resource-show-res-res-type-desc").html("新建选项卡")
                    } else {
                        $("#h-auth-resource-show-res-res-type-desc").html("")
                    }
                })
            }
        })
    },
    tree:function (resId) {
        if (resId === undefined) {
            resId = "-1";
        }
        $.getJSON("/v1/auth/menu/all/except/button",{
            resId:resId
        },function (data) {
            if ( data === null || data.length === 0){
                $.Notify({
                    message:"这个模块中暂时没有配置菜单信息",
                    type:"info"
                });
                $("#h-auth-resource-list-info").Htree({
                    data:[]
                })
            } else {
                var arr = new Array();
                $(data).each(function(index,element){
                    var ijs = {};
                    ijs.id = element.Res_id;
                    ijs.text = element.Res_name;
                    ijs.upId = element.Res_up_id;
                    if (element.Res_attr == "0"){
                        ijs.attr = "1"
                    } else {
                        ijs.attr = "0";
                    }
                    arr.push(ijs)
                });
                $("#h-auth-resource-list-info").HtreeWithLine({
                    data:arr,
                    onChange:function(obj){
                        var id = $(obj).attr("data-id");
                        $.getJSON("/v1/auth/resource/query",{
                            res_id:id
                        },function (e) {
                            if (e.length > 0){
                                var element = e[0];
                                $("#h-auth-resource-show-id").html(element.res_id);
                                $("#h-auth-resource-show-name").html(element.res_name);
                                $("#h-auth-resource-show-up-id").html(element.res_up_id);
                                $("#h-auth-resource-show-attr-desc").html(element.res_attr_desc);
                                $("#h-auth-resource-show-type-desc").html(element.res_type_desc);
                                $("#h-auth-resource-show-type-id").html(element.res_type);
                                $("#h-auth-resource-show-method").html(element.method);
                            }
                        });

                        var theme_id = $("#h-auth-resource-theme-style-code").val();
                        $.getJSON("/v1/auth/resource/queryTheme",{res_id:id,theme_id:theme_id},function (e) {
                            if (e.length===0){
                                $("#h-auth-resource-show-res-bg-color").html("-");
                                $("#h-auth-resource-show-res-class").html("-");
                                $("#h-auth-resource-show-res-img").html("-");
                                $("#h-auth-resource-show-res-url").html("-");
                                $("#h-auth-resource-show-res-group-id").html("-");
                                $("#h-auth-resource-show-res-sort-id").html("-");
                                $("#h-auth-resource-show-res-res-type").html("-");
                                $("#h-auth-resource-show-res-res-type-desc").html("-");
                                $("#h-auth-resource-show-res-new-iframe").html("-");
                            } else {
                                $(e).each(function(index,element){
                                    $("#h-auth-resource-show-res-bg-color").html(element.res_bg_color);
                                    $("#h-auth-resource-show-res-class").html(element.res_class);
                                    $("#h-auth-resource-show-res-img").html(element.res_img);
                                    $("#h-auth-resource-show-res-url").html(element.res_url);
                                    $("#h-auth-resource-show-res-group-id").html(element.group_id);
                                    $("#h-auth-resource-show-res-sort-id").html(element.sort_id);
                                    $("#h-auth-resource-show-res-res-type").html(element.res_open_type);
                                    if (element.res_open_type == "1"){
                                        $("#h-auth-resource-show-res-res-type-desc").html("新tab页展示");
                                    } else {
                                        $("#h-auth-resource-show-res-res-type-desc").html("内部区域展示");
                                    }
                                    $("#h-auth-resource-show-res-new-iframe").html(element.new_iframe);
                                })
                            }
                        })
                    }
                });
            }
        })
    },
    edit:function(){
        var res_id = $("#h-auth-resource-show-id").html();
        if ($.trim(res_id) == "-" || $.trim(res_id) == "") {
            $.Notify({
                message:"请在菜单资源中选择需要编辑的菜单",
                type:"warning",
            });
            return
        }
        // 定义表单对象
        var form = {};
        $.Hmodal({
            header:"编辑资源信息",
            body:$("#h_auth_res_input_form_modify").html(),
            width:"420px",
            callback:function (hmode) {
                $.HAjaxRequest({
                    url:"/v1/auth/resource/update",
                    type:"put",
                    data:$("#h-res-modify-info").serialize(),
                    success:function () {
                        $.Notify({
                            message:"修改菜单资源名称成功",
                            type:"success",
                        });
                        // 刷新右边显示信息
                        $("#h-auth-resource-show-up-id").html(form.res_up_id.value);
                        $("#h-auth-resource-show-method").html(form.method.value);
                        $("#h-auth-resource-show-name").html(form.res_name.value);
                        $(hmode).remove();

                        // 左侧树形结构
                        var resId = $("#h-auth-menu-subsystem-list").val();
                        ResObj.tree(resId);

                    }
                })
            },
            preprocess:function () {
                var res_up_id = $("#h-auth-resource-show-up-id").html();
                var method = $("#h-auth-resource-show-method").html();
                var typ = $("#h-auth-resource-show-type-id").html();
                var res_name = $("#h-auth-resource-show-name").html();
                form = document.getElementById("h-res-modify-info");
                form.res_type.value = typ;
                form.res_id.value = res_id;
                form.res_name.value = res_name;

                if (typ === "4") {
                    $("#h-res-modify-method").parent().hide();
                } else {
                    $("#h-res-modify-method").Hselect({
                        height: "30px",
                        value: method
                    });
                }

                if (res_up_id === "-1"){
                    $("#h-res-modify-res-up-id").attr("disabled","disabled").html("<option value='-1' selected>顶层系统</option>");
                } else {
                    $.getJSON("/v1/auth/resource/node", function (data) {
                        var arr = new Array();
                        $(data).each(function (index, element) {
                            var e = {};
                            e.id = element.resId;
                            e.text = element.resName;
                            e.upId = element.resUpId;
                            arr.push(e);
                        });

                        $("#h-res-modify-res-up-id").Hselect({
                            data: arr,
                            value: res_up_id,
                            height: "30px"
                        });
                    });
                }
            }
        })
    },
    configTheme:function(){
        var res_type = $("#h-auth-resource-show-type-id").html().replace(/(^\s*)|(\s*$)/g, "");
        // 校验资源类型，如果是虚拟节点，则不能配置主题信息
        // 如果没有选择资源，也不能配置资源主题信息
        if (res_type === "4") {
            $.Notify({
                message:"虚拟节点不允许编辑",
                type:"warning"
            });
            return
        } else if (res_type.length === 0) {
            $.Notify({
                message:"请在菜单资源树中,选择需要设置主题的菜单",
                type:"warning"
            });
            return
        }

        // 弹出主题信息配置框
        $.Hmodal({
            header:"配置主题信息",
            body:$("#res_modify_theme_form").html(),
            callback:function (hmode) {
                var form = document.getElementById("h-res-modify-theme-info");
                console.log(form);
                var res_id = $("#h-auth-resource-show-id").html();
                $.HAjaxRequest({
                    url:"/v1/auth/resource/config/theme",
                    type:"Put",
                    data: {
                        res_id: res_id,
                        theme_id: form.theme_id.value,
                        res_url: form.res_url.value,
                        res_class: form.res_class.value,
                        res_img: form.res_img.value,
                        res_bg_color: form.res_bg_color.value,
                        group_id: form.group_id.value,
                        sort_id: form.sort_id.value,
                        res_open_type: form.res_type.value,
                        new_iframe: form.new_iframe.value
                    },
                    success:function(){
                        // 刷新主题信息
                        $("#h-auth-resource-theme-style-code").val(form.theme_id.value);
                        ResObj.updateTheme();

                        // 关闭弹出框，弹出修改成功提示信息
                        $(hmode).remove();
                        $.Notify({
                            message:"配置主题信息成功",
                            type:"success"
                        })
                    }
                })
            },
            preprocess:function(){
                // 获取当前菜单资源，所选择主题配置信息
                var theme_id = $("#h-auth-resource-theme-style-code").val();
                var res_by_color = $("#h-auth-resource-show-res-bg-color").html();
                var res_class = $("#h-auth-resource-show-res-class").html();
                var res_img = $("#h-auth-resource-show-res-img").html();
                var res_url = $("#h-auth-resource-show-res-url").html();
                var res_group_id = $("#h-auth-resource-show-res-group-id").html();
                var res_sort_id = $("#h-auth-resource-show-res-sort-id").html();
                var open_type = $("#h-auth-resource-show-res-res-type").html();
                var new_iframe = $("#h-auth-resource-show-res-new-iframe").html();

                // 填充表单
                $("#h-res-modify-res-class").Hselect({
                    height:"30px",
                    value:res_class
                });
                $("#h-res-modify-res-type").Hselect({
                    height: "30px",
                    value: open_type
                });
                $("#h-res-modify-new-iframe").Hselect({
                    height:"30px",
                    value: new_iframe
                });
                $("#h-res-modify-res-img").val(res_img);
                $("#h-res-modify-res-bg-color").val(res_by_color);
                $("#h-res-modify-group-id").Hselect({
                    value: res_group_id,
                    height: "30px"
                });
                $("#h-res-modify-sort-id").val(res_sort_id);
                $("#h-res-modify-theme-id").Hselect({
                    value: theme_id,
                    height: "30px"
                });
                $("#h-res-modify-res-url").val(res_url);
            }
        })
    }
};

$(document).ready(function() {
    /*
     * 调整属性信息显示框大小
     * 高度填充全屏高度
     * */
    var hwindow = document.documentElement.clientHeight;
    $("#h-auth-resource-tree-info").height(hwindow - 130);
    $("#h-auth-resource-details-info").height(180);
    $("#h-auth-resource-theme-info").height(hwindow - 350);
    $("#h-auth-resource-list-info").height(hwindow - 204);
    ResObj.tree("-1");

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

        $("#h-auth-menu-subsystem-list").Hselect({
            data:arr,
            height:"24px",
            value:"-1",
            onclick:function () {
                var resId = $("#h-auth-menu-subsystem-list").val();
                ResObj.tree(resId);
            }
        })
    });

});
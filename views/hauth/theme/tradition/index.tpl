<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="description" content="A front-end template that helps you build fast, modern mobile web apps.">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0">
    <title>Asofdate</title>

    <!-- Add to homescreen for Chrome on Android -->
    <meta name="mobile-web-app-capable" content="yes">
    <!--<link rel="icon" sizes="192x192" href="/static/images/mdui/android-desktop.png">-->

    <!-- Add to homescreen for Safari on iOS -->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-title" content="Material Design Lite">
    <!--<link rel="apple-touch-icon-precomposed" href="/static/images/mdui/ios-desktop.png">-->

    <!-- Tile icon for Win8 (144x144 + tile color) -->
    <!--<meta name="msapplication-TileImage" content="/static/images/mdui/touch/ms-touch-icon-144x144-precomposed.png">-->
    <!--<meta name="msapplication-TileColor" content="#3372DF">-->

    <!--static-->
    <link rel="stylesheet" href="/static/css/metro.css">
    <link rel="stylesheet" href="/static/bootstrap-3.3.7-dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="/static/Font-Awesome-3.2.1/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="/static/font-awesome-4.7.0/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="/static/theme/common.css"/>
    <link rel="stylesheet" href="/static/theme/tradition/index.css" type="text/css" />
    <link rel="stylesheet" href="/static/css/animate.css"/>
    <link rel="stylesheet" href="/static/nprogress/nprogress.css"/>

    <script type="text/javascript" src="/static/js/jquery-3.1.1.min.js"></script>
    <script type="text/javascript" src="/static/nprogress/nprogress.js"></script>
    <script type="text/javascript" src="/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/static/theme/tradition/utils.min.js"></script>

    <!--bootstrap-table表格-->
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="/static/bootstrap-table/dist/bootstrap-table.min.css">
    <!-- Latest compiled and minified JavaScript -->
    <script src="/static/bootstrap-table/dist/bootstrap-table.min.js"></script>
    <!-- Latest compiled and minified Locales -->
    <script src="/static/bootstrap-table/dist/locale/bootstrap-table-zh-CN.min.js"></script>

    <!--bootstrap switch-->
    <link rel="stylesheet" href="/static/bootstrap-switch-master/dist/css/bootstrap3/bootstrap-switch.min.css"/>
    <script src="/static/bootstrap-switch-master/dist/js/bootstrap-switch.min.js"></script>

    <!--webupload-->
    <link rel="stylesheet" href="/static/webuploader/dist/webuploader.css"/>
    <script src="/static/webuploader/dist/webuploader.min.js"></script>


    <link rel="stylesheet" href="/static/css/material.indigo-blue.min.css">
    <link rel="stylesheet" href="/static/css/styles.css">
    <script type="text/javascript" src="/static/js/material.min.js"></script>
</head>
<body>
<div class="demo-layout mdl-layout mdl-js-layout mdl-layout--fixed-drawer mdl-layout--fixed-header">
    <header class="mdl-color-text--grey-100"
            style="z-index: 8;background-color: #367fa9">
        <div class="mdl-layout__header-row"
             style="padding-left: 0px; padding-right: 0px;">
            <header class="sso-drawer-header">
                <img onclick="Hutils.backHome()"
                     style="cursor: pointer;"
                     src="/static/images/mdui/logo.png"
                     data-toggle="tooltip"
                     data-placement="bottom"
                     title="点击返回系统主菜单"/>
            </header>
            <div class="mdl-layout-spacer"></div>
            <div style="height: 36px; line-height: 36px;">
                <button class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-color-text--white"
                        onclick="Hutils.UserMgrInfo()"
                        style="height: 36px; line-height: 36px; text-transform: none;">
                    <i class="fa fa-user">&nbsp;<hzwy id="hzwy23-user-id">{{.}}</hzwy></i>
                </button>
                <button class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-color-text--white"
                        onclick="changemodifypassword()"
                        style="height: 36px; line-height: 36px; text-transform: none;">
                    <i class="fa fa-user-secret"> 密码</i>
                </button>
                <button class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-color-text--white"
                        onclick="Hutils.modifyThemeInfo()"
                        style="height: 36px; line-height: 36px; text-transform: none;">
                    <i class="fa fa-cog"> 主题</i>
                </button>
                <button onclick="Hutils.HLogOut()"
                        class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-color-text--white"
                        style="height: 36px; line-height: 36px;">
                    <i class="fa fa-power-off"> 退出</i>
                </button>
            </div>
        </div>
    </header>
    <div id="sso-menu-side"
         class="demo-drawer mdl-layout__drawer menu-bar"
         style="padding-top: 64px;display: none;">
        <nav id="h-sso-menus-content"
             class="demo-navigation mdl-navigation h-navigation-list">
        </nav>
    </div>
    <main id="sso-main-content" class="mdl-layout__content" style="margin-left: 0px;">
        <div class="mdl-color--grey-100" style="display: none; width: 100%; z-index: 100; height: 26px; line-height: 26px; position: fixed; margin-top: 0px;">
            <ul class="menu-bar">
                <li style="height: 26px; line-height: 26px;float: left; border-bottom: #ededed solid 1px;">
                    <button onclick="ShowOrHideSide()"
                            style="margin-top: -5px; height: 26px; line-height: 26px; outline: none;border: none;"
                            data-toggle="tooltip"
                            data-placement="right"
                            title="显示/隐藏左侧菜单栏"
                            class="btn btn-default btn-xs">
                        <i class="icon-exchange"></i>
                    </button>
                </li>
                <li id="h-wisrc-tablist" style="float: left;height: 26px; line-height: 26px; border-left: #ededed solid 1px; border-bottom: #ededed solid 1px; border-right: #ededed solid 1px;">
                    <button style="margin-top: -4px; height: 26px; line-height: 26px; padding-left: 6px; padding-right: 6px; border: none;"
                            class="btn btn-default btn-xs" type="button"
                            data-toggle="collapse" data-target="#h-wisrc-tab-btn-list"
                            aria-expanded="false" aria-controls="h-wisrc-tab-btn-list">
                        <i class="icon-double-angle-down"></i>
                    </button>
                    <div class="collapse pull-left" id="h-wisrc-tab-btn-list"
                         style="position: absolute; background-color: #fafafa; z-index: 20;width: 80px;">
                        <ul class="h-wisrc-tab-btn__click">
                            <li onclick="Hutils.closeAllTab(this)">关闭全部</li>
                            <li onclick="Hutils.closeOtherTab(this)">关闭其他</li>
                        </ul>
                    </div>
                </li>
            </ul>
        </div>
        <div id="h-sso-window"
             class="mdl-color--white mdl-cell mdl-cell--12-col mdl-grid">
            <div data-id="HomePage" class="h-wisrc-content h-wisrc-content-show">
                <div id="bigdata-platform-subsystem"
                     class="mdl-shadow--16dp"
                     style="margin: -16px -16px; background-size: cover;background-color: #367fa9; overflow: hidden;display: none;">
                    <div id="wrap" class="col-sm-12 col-md-12 col-lg-12" style="overflow: auto;">
                        <div style="height: 30px;"></div>
                        <div id="h-system-service" class="col-sm-12 col-md-6 col-lg-4"></div>
                        <div id="h-mas-service" class="col-sm-12 col-md-6 col-lg-4"></div>
                        <div id="h-other-service"  class="col-sm-12 col-md-6 col-lg-4"></div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
<script type="text/javascript">

    function ShowOrHideSide() {
        var obj = document.getElementById("sso-main-content");
        var width = $("#sso-menu-side").width();
        if (obj.style.marginLeft == "0px") {
            $("#sso-menu-side").animate({
                'left':'0px',
            });

            $("#sso-main-content").animate({
                "margin-left":width,
            });

        } else {
            $("#sso-menu-side").animate({
                "left":(-1)*width,
                "display":"block",
            });

            $("#sso-main-content").animate({
                "margin-left":"0px",
            });
        }

    }

    $(document).ready(function () {
        $("#h-sso-menus-content").height(document.documentElement.clientHeight-64);
        $("#wrap").height(document.documentElement.clientHeight - 66);
        Hutils.initMenu(0,-1,"系统服务","管理会计","公共信息");
        var width = $("#sso-menu-side").width();
        $("#sso-menu-side").css({
            "left":(-1)*width,
            "display":"block",
        });
        $("#bigdata-platform-subsystem").css({
            "width":document.documentElement.clientWidth+32,
        }).show();

        $(function () {
            $('[data-toggle="tooltip"]').tooltip()
        })
    });

    window.onresize = function () {
        $("#h-sso-menus-content").height(document.documentElement.clientHeight-64);
        $("#wrap").height(document.documentElement.clientHeight - 66);
    };

    var changeTheme = function (id) {
        $.HAjaxRequest({
            url:"/v1/auth/theme/update",
            type:'post',
            dataType:'json',
            data:{theme_id:id},
            success:function () {
                window.location.href="/v1/auth/HomePage"
            }
        })
    };

    var changemodifypassword = function(){
        $.Hmodal({
            header:"密码修改",
            body:$("#h-user-modify-password").html(),
            width:"420px",
            preprocess:function () {
                var user_id = $("#hzwy23-user-id").html().trim();
                $("#h-modify-user-id").val(user_id)
            },
            callback:function(hmode){
                var newpd = $("#plat-change-passwd").find('input[name="newpasswd"]').val();
                var orapd = $("#plat-change-passwd").find('input[name="orapasswd"]').val();
                var surpd = $("#plat-change-passwd").find('input[name="surepasswd"]').val();
                if ($.trim(newpd) =="" || $.trim(orapd) == "" || $.trim(surpd)  == "" ){
                    $.Notify({
                        message:"不能将密码设置成空格",
                        type:"danger",
                    });
                    return
                }else if(newpd != surpd){
                    $.Notify({
                        message:"两次输入的新密码不一致，请确认是否存在多余的空格",
                        type:"danger",
                    });
                    return
                }
                $.HAjaxRequest({
                    type:"post",
                    url:"/v1/auth/passwd/update",
                    data:$("#plat-change-passwd").serialize(),
                    dataType:"json",
                    success:function(){
                        $(hmode).remove();
                        $.Notify({
                            message:"修改密码成功",
                            type:"success",
                        })
                    }
                });
            }
        })
    };
</script>

<script id="mas-modify-theme" type="text/html">
    <div style="font-size: 12px;font-weight: 600;" class="page-header">全屏主题：</div>
    <button onclick="changeTheme(1001)" class="btn btn-lg theme-green-color" style="color: white;">
    </button>
    <button onclick="changeTheme(1004)" class="btn btn-lg theme-cyan-color" style="color: white;">
    </button>
    <button onclick="changeTheme(1002)" class="btn btn-lg theme-blue-color" style="color: white;">
    </button>
    <button onclick="changeTheme(1003)" class="btn btn-lg theme-apple-color" style="color: white;">
    </button>
    <div style="font-size: 12px;font-weight: 600;" class="page-header">传统主题：</div>
    <button onclick="changeTheme(1005)" class="btn btn-lg theme-tradition-color" style="color: white;">
    </button>
</script>

<script id="mas-passwd-prop" type="text/html">
    <div class="panel panel-default">
        <div class="panel-heading" style="height: 42px; line-height: 42px;">
        </div>
        <table class="table table-bordered table-responsive">
            <tr style="height: 36px;line-height: 36px;">
                <td style="text-align: right;">用户id:&nbsp;</td>
                <td id="h-user-details-user-id" style="font-weight: 600">user_id</td>
                <td style="text-align: right;">用户名称:&nbsp;</td>
                <td id="h-user-details-user-name" style="font-weight: 600">user_name</td>
            </tr>
            <tr style="height: 36px;line-height: 36px;">
                <td style="text-align: right;">邮箱:&nbsp;</td>
                <td id="h-user-details-user-email" style="font-weight: 600">user_email</td>
                <td style="text-align: right;">手机号:&nbsp;</td>
                <td id="h-user-details-user-phone" style="font-weight: 600">user_phone</td>
            </tr>
            <tr style="height: 36px;line-height: 36px;">
                <td style="text-align: right;">组织部门编码:&nbsp;</td>
                <td id="h-user-details-user-org" style="font-weight: 600">user_dept</td>
                <td style="text-align: right;">组织部门描述:&nbsp;</td>
                <td id="h-user-details-user-org-name" style="font-weight: 600">user_domain</td>
            </tr>
            <tr style="height: 36px;line-height: 36px;">
                <td style="text-align: right;">创建人:&nbsp;</td>
                <td id="h-user-details-user-create" style="font-weight: 600">user_create</td>
                <td style="text-align: right;">创建时间:&nbsp;</td>
                <td id="h-user-details-user-create-date" style="font-weight: 600">user_create_date</td>
            </tr>
            <tr style="height: 36px;line-height: 36px;">
                <td style="text-align: right;">修改人:&nbsp;</td>
                <td id="h-user-details-user-modify" style="font-weight: 600">user_create</td>
                <td style="text-align: right;">修改时间:&nbsp;</td>
                <td id="h-user-details-user-modify-date" style="font-weight: 600">user_create_date</td>
            </tr>
        </table>
    </div>
</script>
<script id="h-user-modify-password" type="text/html">
    <form id="plat-change-passwd" class="row">
        <div class="form-group col-sm-12 col-md-12 col-lg-12">
            <label class="h-label" style="width: 100%;">账　号：</label>
            <input id="h-modify-user-id" readonly="readonly" class="form-control" style="width: 100%;height: 30px; line-height: 30px;" type="text" name="userid"/>
        </div>
        <div class="form-group col-sm-12 col-md-12 col-lg-12">
            <label class="h-label" style="width: 100%;">原密码：</label>
            <input placeholder="密码长度必须大于6位，小于30位" class="form-control" style="width:100%;height: 30px; line-height: 30px;" type="password" name="orapasswd"/>
        </div>
        <div class="form-group col-sm-12 col-md-12 col-lg-12">
            <label class="h-label" style="width: 100%;">新密码：</label>
            <input placeholder="密码长度必须大于6位，小于30位" class="form-control" style="width:100%;height: 30px; line-height: 30px;" type="password" name="newpasswd"/>
        </div>
        <div class="form-group col-sm-12 col-md-12 col-lg-12">
            <label class="h-label" style="width: 100%;">确认密码：</label>
            <input placeholder="请确认新密码信息" class="form-control" style="height: 30px; line-height: 30px; width: 100%;" type="password" name="surepasswd"/>
        </div>
    </form>
</script>
<script id="h-sso-main-menus" type="text/html">
    <div data-id="HomePage" class="h-wisrc-content h-wisrc-content-show">
        <div id="bigdata-platform-subsystem"
             class="mdl-shadow--16dp"
             style="background-color: #367fa9; margin: -16px -16px; background-size: cover; overflow: hidden;display: none;">
            <div id="wrap" class="col-sm-12 col-md-12 col-lg-12" style="overflow: auto;">
                <div style="height: 30px;"></div>
                <div id="h-system-service" class="col-sm-12 col-md-6 col-lg-4"></div>
                <div id="h-mas-service" class="col-sm-12 col-md-6 col-lg-4"></div>
                <div id="h-other-service"  class="col-sm-12 col-md-6 col-lg-4"></div>
            </div>
        </div>
    </div>
</script>
<script type="text/javascript" src="/static/js/laydate.js"></script>
<script type="text/javascript" src="/static/js/bootstrap-notify.min.js"></script>
<script type="text/javascript" src="/static/js/download.js"></script>
<script type="text/javascript" src="/static/js/spin.min.js"></script>
</body>
</html>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>wisrc 单点登录</title>

    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="/static/js/jquery-3.1.1.min.js"></script>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:regular,bold,italic,thin,light,bolditalic,black,medium&amp;lang=en">
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link rel="stylesheet" href="/static/css/material.min.css">
    <script type="text/javascript" src="/static/js/material.min.js"></script>
</head>
<body style="background-color: #1488c6">
<div class="mdl-grid">
    <div id="h-login-login-input" class="mdl-cell mdl-cell--4-col mdl-cell--4-offset" style="text-align: center;display: none;">
        <img src="/static/images/mdui/logo.png"/>
        <br/>
        <div style="width: 420px;margin-top: 30px;" class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
            <input style="border-bottom:#cccccc solid 2px;" name="username" class="mdl-textfield__input mdl-color-text--white" type="text" id="username">
            <label class="mdl-textfield__label" style="color: #fcfcfc" for="username">账 号</label>
        </div>
        <br/>
        <div style="width: 420px;" class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
            <input style="border-bottom:#cccccc solid 2px;" name="password" class="mdl-textfield__input mdl-color-text--white" type="password" id="password">
            <label class="mdl-textfield__label" style="color: #fcfcfc" for="password">密 码</label>
        </div>
        <br/>
        <button style="width: 120px;font-weight: 600; float: right;margin-top: 20px;" onclick="LoginSubmit()" class="mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--accent">登 陆</button>
    </div>
</div>
<div id="sso-snackbar" class="mdl-js-snackbar mdl-snackbar" style="background-color: #ffb61f">
    <div class="mdl-snackbar__text"></div>
    <button class="mdl-snackbar__action" type="button"></button>
</div>
</body>
<script type="text/javascript" src="/static/js/utils.min.js"></script>
<script>
    function LoginSubmit(){
        var user = $("#h-login-login-input").find("input[name='username']").val();
        var psd = $("#h-login-login-input").find("input[name='password']").val();

        $.HAjaxRequest({
            url:"/v1/auth/login",
            type:"POST",
            data:{
                username:user,
                password:psd,
                duration:"43200",
            },
            dataType:"json",
            success:function(data){
                window.location.href="/v1/auth/HomePage";
            },
            error:function(msg){
                var data = {
                    message: '应用服务异常，请联系管理员',
                    timeout: 2000,
                };
                var snackbarContainer = document.querySelector('#sso-snackbar');
                if (msg.responseText == undefined){
                    console.log(msg);
                    snackbarContainer.MaterialSnackbar.showSnackbar(data);
                    return
                }
                var imsg = JSON.parse(msg.responseText);
                data.message = imsg.retMsg;
                snackbarContainer.MaterialSnackbar.showSnackbar(data);
                console.log(imsg);
            }
        });
    };

    $(document).ready(function () {
        var h = document.documentElement.clientHeight;
        var hh = (h-360)/2;
        var obj = document.getElementById("h-login-login-input");
        obj.style.paddingTop = hh+"px";
        obj.style.display = "block";
    });

    $(document).keydown(function(e){
        if (e.keyCode == '13'){
            setTimeout(LoginSubmit,100)
        }
    });
</script>
</html>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <link rel="stylesheet" href="/static/css/metro.css">
    <link rel="stylesheet" href="/static/bootstrap-3.3.7-dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="/static/Font-Awesome-3.2.1/css/font-awesome.min.css"/>

    <link rel="stylesheet" href="/static/theme/common.css"/>
    <link rel="stylesheet" href="/static/theme/blue/index.css" type="text/css" />
    <link rel="stylesheet" href="/static/css/animate.css"/>
    <link rel="stylesheet" href="/static/nprogress/nprogress.css"/>

    <script type="text/javascript" src="/static/js/jquery-3.1.1.min.js"></script>
    <script src="/static/nprogress/nprogress.js"></script>

    <script type="text/javascript" src="/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/static/jquery-i18n-properties/jquery.i18n.properties.min.js"></script>
    <script type="text/javascript" src="/static/js/utils.min.js"></script>

    <script type="text/javascript" src="/static/js/spin.min.js"></script>
</head>
<body>
<script type="text/javascript">
    $(document).ready(function(){
        $.Hconfirm({
            cancelBtn:false,
            header:"连接已断开",
            body:"用户连接已断开，请重新登录",
            callback:function () {
                window.location.href="/"
            }
        })
    })
</script>
</body>
</html>
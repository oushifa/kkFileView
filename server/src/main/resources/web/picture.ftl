<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>图片预览</title>
    <#include "*/commonHeader.ftl">
    <link rel="stylesheet" href="css/viewer.min.css">
    <script src="js/viewer.min.js"></script>
    <script src="js/base64.min.js"></script>
    <style>
        body {
            background-color: #f1f3f5;
        }
        .viewer-container:focus {
            outline: none !important;
        }
        .viewer-container:focus-visible {
            outline: 2px solid rgba(95, 107, 122, 0.65) !important;
            outline-offset: 2px;
            box-shadow: 0 0 0 4px rgba(95, 107, 122, 0.14);
        }
        #image { width: 800px; margin: 0 auto; font-size: 0;}
        #image li {  display: inline-block;width: 50px;height: 50px; margin-left: 1%; padding-top: 1%;}
        /*#dowebok li img { width: 200%;}*/
    </style>
</head>
<body>

<ul id="image">
    <#list imgUrls as img>
    <#if img?contains("http://") || img?contains("https://")|| img?contains("ftp://")|| img?contains("file://")>
    <#assign finalUrl="${img}">
    <#else>
    <#assign finalUrl="${baseUrl}${img}">
    </#if>
    <li><div src="${finalUrl}" data-original-url="${finalUrl}" style="display: none"></li>
    </#list>
</ul>

<script>
    // 获取反代配置
    var kkagent = '${kkagent}';
    var baseUrl = '${baseUrl}'.endsWith('/') ? '${baseUrl}' : '${baseUrl}' + '/';
    // 处理图片URL，如果需要反代则替换URL
    function processImageUrls() {
        var imageElements = document.querySelectorAll('#image li div');
        
        imageElements.forEach(function(imgDiv) {
            var originalUrl = imgDiv.getAttribute('data-original-url');
            var finalUrl = originalUrl;
            
            // 检查是否需要反代
            // 如果页面是 HTTPS，而图片是 HTTP（混合内容 Mixed Content），浏览器会拦截，此时强制通过 getCorsFile 代理加载
            var isMixedContent = window.location.protocol === 'https:' && originalUrl.startsWith('http://');
            if (kkagent === 'true' || isMixedContent) {
                finalUrl = baseUrl + 'getCorsFile?urlPath=' + encodeURIComponent(Base64.encode(originalUrl)) + "&key=${kkkey}";
            }
            
            // 更新src属性
            imgDiv.setAttribute('src', finalUrl);
        });
    }
    
    // 初始化图片查看器
    function initImageViewer() {
        var viewer = new Viewer(document.getElementById('image'), {
            url: 'src',
            navbar: false,
            button: false,
            backdrop: false,
            loop: true,
        });
        viewer.view(0); // 0 是图片的索引，如果你想点击第一张图片，索引为 0
    }
    
    // 页面加载完成后初始化
    document.addEventListener('DOMContentLoaded', function () {
        // 先处理图片URL
        processImageUrls();
        
        // 然后初始化图片查看器
        initImageViewer();
    });
    
    /*初始化水印*/
    window.onload = function() {
        initWaterMark();
    }
</script>
</body>
</html>

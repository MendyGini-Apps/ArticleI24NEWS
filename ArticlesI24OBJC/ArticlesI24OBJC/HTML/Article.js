var intervalID;
window.addEventListener('load', function(event) {
    notifyHeight();
    intervalID = setInterval(startNotifyHeight, 1000);
});

var contentBody = document.getElementById('contentBody');
contentBody.addEventListener('resize', function(event) { notifyHeight() });

function notifyHeight() {
    window.webkit.messageHandlers.sizeNotification.postMessage({ height: contentBody.scrollHeight });
}

var oldScrollHeights = [];

function startNotifyHeight() {
    if (oldScrollHeights.length > 0 && oldScrollHeights.every(isSameHeight)) {
        clearInterval(intervalID);
        return;
    }
    oldScrollHeights.unshift(contentBody.scrollHeight);
    if (oldScrollHeights.length > 16) {
        oldScrollHeights.pop();
    }
    notifyHeight();
}

function isSameHeight(height, index, arr) {
    if (arr.length < 3) {
        return false;
    }
    if (index === 0) {
        return true;
    }
    return height === arr[index - 1];
}

addClickEventOnAllImages();

function addClickEventOnAllImages() {
    var images = document.getElementsByTagName("img");
    for (var i = 0; i < images.length; i++) {
        var image = images[i];
        image.onclick = function(event) {
            var a = document.createElement('a');
            a.setAttribute('href', image.src)
            a.click()
        };
    }
}

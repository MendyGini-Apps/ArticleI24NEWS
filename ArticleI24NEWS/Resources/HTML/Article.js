var intervalID;
window.addEventListener('load', function(event) {
                        notifyHeight();
                        intervalID = setInterval(startNotifyHeight, 2000);
                        });

var contentBody = document.getElementById('contentBody');
contentBody.addEventListener('resize', function(event){notifyHeight()});

function notifyHeight()
{
    window.webkit.messageHandlers.sizeNotification.postMessage({height:contentBody.scrollHeight});
}

var oldScrollHeights = [];
function startNotifyHeight()
{
    if (oldScrollHeights.length > 0 && oldScrollHeights.every(isSameHeight))
    {
        clearInterval(intervalID);
        return;
    }
    oldScrollHeights.unshift(contentBody.scrollHeight);
    if (oldScrollHeights.length > 4)
    {
        oldScrollHeights.pop();
    }
    notifyHeight();
}

function isSameHeight(height, index, arr)
{
    if (arr.length < 3)
    {
        return false;
    }
    if (index === 0)
    {
        return true;
    }
    return height === arr[index - 1];
}
